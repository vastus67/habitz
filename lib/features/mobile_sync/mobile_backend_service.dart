import 'dart:convert';

import 'package:drift/drift.dart' as drift;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:habitz/core/config/app_config.dart';
import 'package:habitz/core/database/app_database.dart';
import 'package:habitz/core/database/database_provider.dart';
import 'package:habitz/core/utils/id_generator.dart';
import 'package:habitz/features/auth/providers/auth_provider.dart';
import 'package:habitz/features/auth/providers/onboarding_state.dart';
import 'package:habitz/features/habits/domain/habit.dart';
import 'package:habitz/features/plans/domain/workout_models.dart';
import 'package:habitz/features/profile/domain/user_profile.dart';
import 'package:habitz/features/profile/providers/profile_provider.dart';

final mobileBackendServiceProvider = Provider<MobileBackendService>((ref) {
  return MobileBackendService(ref);
});

class MobileBackendService {
  MobileBackendService(this._ref, {http.Client? client}) : _client = client ?? http.Client();

  final Ref _ref;
  final http.Client _client;

  Future<RemoteRecommendations> fetchRecommendations(OnboardingState state) async {
    final data = await _post(
      '/api/onboarding/recommendations',
      {
        'goals': _goalKeys(state.selectedGoals),
        'sex_variant': state.sexVariant?.name,
        'fitness_level': state.fitnessLevel?.name,
        'equipment': state.equipment?.name,
        'wake_time': state.wakeTime,
      },
    );

    return RemoteRecommendations(
      habits: (data['habits'] as List? ?? const [])
          .map((item) => RemoteHabitRecommendation.fromMap(Map<String, dynamic>.from(item as Map)))
          .toList(),
      plans: (data['plans'] as List? ?? const [])
          .map((item) => RemotePlanSummary.fromMap(Map<String, dynamic>.from(item as Map)))
          .toList(),
    );
  }

  Future<void> completeOnboarding(
    OnboardingState state, {
    required String athleteName,
  }) async {
    final data = await _post(
      '/api/onboarding/complete',
      {
        'name': athleteName,
        'goals': _goalKeys(state.selectedGoals),
        'sex_variant': state.sexVariant?.name,
        'fitness_level': state.fitnessLevel?.name,
        'equipment': state.equipment?.name,
        'wake_time': state.wakeTime,
        'habit_keys': state.selectedHabits.map(_habitKey).toList(),
        'selected_plan_id': state.selectedPlanId,
      },
    );

    final user = Map<String, dynamic>.from(data['user'] as Map);
    await _syncProfile(user, state);
    await _syncHabits((data['habits'] as List? ?? const []).cast<dynamic>(), state.wakeTime);
    final activePlanId = user['active_plan_id'] as String?;
    if (activePlanId != null && activePlanId.isNotEmpty) {
      await fetchPlanDetail(activePlanId);
    }
  }

  Future<List<RemotePlanSummary>> fetchPlans() async {
    final data = await _get('/api/plans');
    final plans = (data['plans'] as List? ?? const [])
        .map((item) => RemotePlanSummary.fromMap(Map<String, dynamic>.from(item as Map)))
        .toList();
    for (final plan in plans) {
      await _syncPlanSummary(plan);
    }
    return plans;
  }

  Future<RemotePlanDetail> fetchPlanDetail(String planId) async {
    final data = await _get('/api/plans/$planId');
    final detail = RemotePlanDetail.fromMap(Map<String, dynamic>.from(data['plan'] as Map));
    await _syncPlanDetail(detail);
    return detail;
  }

  Future<void> activatePlan(String planId) async {
    await _post('/api/plans/$planId/activate', const {});
    final profile = await _ref.read(profileRepositoryProvider).fetch();
    if (profile != null) {
      await _ref.read(profileRepositoryProvider).save(profile, activePlanId: planId);
      await _ref.read(profileControllerProvider.notifier).load();
    }
    await fetchPlanDetail(planId);
  }

  Future<Map<String, dynamic>> _get(String path) async {
    final sessionToken = _requireSessionToken();
    final response = await _client.get(
      AppConfig.apiUri.resolve(path),
      headers: {
        'Authorization': 'Bearer $sessionToken',
      },
    );
    final decoded = jsonDecode(response.body);
    if (response.statusCode >= 400) {
      final detail = decoded is Map<String, dynamic> ? decoded['detail'] : null;
      throw Exception(detail ?? 'Request failed');
    }
    return Map<String, dynamic>.from(decoded as Map);
  }

  Future<Map<String, dynamic>> _post(String path, Map<String, dynamic> body) async {
    final sessionToken = _requireSessionToken();
    final response = await _client.post(
      AppConfig.apiUri.resolve(path),
      headers: {
        'Authorization': 'Bearer $sessionToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );
    final decoded = jsonDecode(response.body);
    if (response.statusCode >= 400) {
      final detail = decoded is Map<String, dynamic> ? decoded['detail'] : null;
      throw Exception(detail ?? 'Request failed');
    }
    return Map<String, dynamic>.from(decoded as Map);
  }

  String _requireSessionToken() {
    final token = _ref.read(authControllerProvider).valueOrNull?.sessionToken;
    if (token == null || token.isEmpty) {
      throw Exception('Not authenticated');
    }
    return token;
  }

  Future<void> _syncProfile(Map<String, dynamic> user, OnboardingState state) async {
    final repository = _ref.read(profileRepositoryProvider);
    final current = await repository.fetch();
    final profile = UserProfile(
      id: current?.id ?? IdGenerator.deterministic('profile', ['main']),
      name: (user['name'] as String?) ?? current?.name ?? 'Athlete',
      sexVariant: state.sexVariant ?? current?.sexVariant ?? SexVariant.unisex,
      primaryGoal: _mapPrimaryUserGoal(state.selectedGoals),
      equipment: state.equipment ?? current?.equipment ?? EquipmentType.home,
      wakeTime: state.wakeTime,
      onboardingCompleted: (user['onboarding_completed'] as bool?) ?? true,
      proEnabled: current?.proEnabled ?? false,
    );
    await repository.save(profile, activePlanId: user['active_plan_id'] as String?);
    _ref.read(hasCompletedOnboardingProvider.notifier).state = true;
    await _ref.read(profileControllerProvider.notifier).load();
  }

  Future<void> _syncHabits(List<dynamic> rawHabits, String wakeTime) async {
    final db = _ref.read(appDatabaseProvider);
    await db.transaction(() async {
      await db.delete(db.habitLogEntries).go();
      await db.delete(db.habitEntries).go();
      for (final item in rawHabits) {
        final habit = Map<String, dynamic>.from(item as Map);
        await db.into(db.habitEntries).insertOnConflictUpdate(
              HabitEntriesCompanion.insert(
                id: habit['habit_id'] as String? ?? IdGenerator.deterministic('habit', [habit['key'] as String? ?? habit['title'] as String]),
                title: habit['title'] as String,
                type: _habitTypeFromBackend((habit['type'] as String?) ?? 'binary').name,
                targetValue: drift.Value(((habit['target'] as num?) ?? 1).toDouble()),
                unit: drift.Value((habit['unit'] as String?) ?? 'done'),
                scheduleDays: '1,2,3,4,5,6,7',
                reminders: wakeTime,
                createdAt: DateTime.now(),
                category: drift.Value(habit['category'] as String?),
              ),
            );
      }
    });
  }

  Future<void> _syncPlanSummary(RemotePlanSummary plan) async {
    final db = _ref.read(appDatabaseProvider);
    await db.into(db.workoutPlanEntries).insertOnConflictUpdate(
          WorkoutPlanEntriesCompanion.insert(
            id: plan.id,
            name: plan.name,
            goal: plan.goal.name,
            level: plan.level.name,
            sexVariant: plan.sexVariant.name,
            daysPerWeek: plan.daysPerWeek,
            durationWeeks: plan.durationWeeks,
            equipment: plan.equipment.name,
            description: plan.description,
            tags: plan.tags.join(','),
          ),
        );
  }

  Future<void> _syncPlanDetail(RemotePlanDetail plan) async {
    final db = _ref.read(appDatabaseProvider);
    await _syncPlanSummary(plan);

    await db.transaction(() async {
      final oldDays = await (db.select(db.workoutDayEntries)..where((tbl) => tbl.planId.equals(plan.id))).get();
      for (final day in oldDays) {
        await (db.delete(db.workoutSetEntries)..where((tbl) => tbl.workoutDayId.equals(day.id))).go();
      }
      await (db.delete(db.workoutDayEntries)..where((tbl) => tbl.planId.equals(plan.id))).go();

      for (final day in plan.days) {
        await db.into(db.workoutDayEntries).insertOnConflictUpdate(
              WorkoutDayEntriesCompanion.insert(
                id: day.id,
                planId: plan.id,
                dayIndex: day.dayIndex,
                title: day.title,
              ),
            );

        for (final exercise in day.exercises) {
          await db.into(db.exerciseEntries).insertOnConflictUpdate(
                ExerciseEntriesCompanion.insert(
                  id: exercise.id,
                  name: exercise.name,
                  primaryMuscles: exercise.primaryMuscles.join(','),
                  equipment: exercise.equipment.name,
                  instructions: exercise.instructions,
                  videoUrl: drift.Value(exercise.videoUrl),
                ),
              );

          await db.into(db.workoutSetEntries).insertOnConflictUpdate(
                WorkoutSetEntriesCompanion.insert(
                  id: '${day.id}_${exercise.id}',
                  workoutDayId: day.id,
                  exerciseId: exercise.id,
                  sets: exercise.sets,
                  reps: exercise.reps,
                  restSeconds: exercise.restSeconds,
                  weightType: exercise.weightType,
                  tempo: drift.Value(null),
                  progressionRule: drift.Value(null),
                ),
              );
        }
      }
    });
  }

  List<String> _goalKeys(Set<OnboardingGoal> goals) => goals.map((goal) {
        switch (goal) {
          case OnboardingGoal.buildMuscle:
            return 'build_muscle';
          case OnboardingGoal.loseFat:
            return 'lose_fat';
          case OnboardingGoal.improveDiscipline:
            return 'improve_discipline';
          case OnboardingGoal.improveHealth:
            return 'improve_health';
          case OnboardingGoal.buildDailyHabits:
            return 'build_daily_habits';
          case OnboardingGoal.increaseEnergy:
            return 'increase_energy';
        }
      }).toList();

  String _habitKey(HabitRecommendation habit) {
    switch (habit) {
      case HabitRecommendation.water:
        return 'water';
      case HabitRecommendation.walk:
        return 'walk';
      case HabitRecommendation.morningStretch:
        return 'stretch';
      case HabitRecommendation.meditation:
        return 'meditation';
      case HabitRecommendation.sleep:
        return 'sleep';
      case HabitRecommendation.workout:
        return 'workout';
    }
  }

  HabitType _habitTypeFromBackend(String value) {
    switch (value) {
      case 'count':
        return HabitType.count;
      case 'duration':
        return HabitType.duration;
      case 'target':
        return HabitType.target;
      case 'timedReminder':
        return HabitType.timedReminder;
      default:
        return HabitType.binary;
    }
  }

  UserGoal _mapPrimaryUserGoal(Set<OnboardingGoal> goals) {
    if (goals.contains(OnboardingGoal.buildMuscle)) return UserGoal.strength;
    if (goals.contains(OnboardingGoal.loseFat)) return UserGoal.fatLoss;
    if (goals.contains(OnboardingGoal.improveHealth)) return UserGoal.mobility;
    if (goals.contains(OnboardingGoal.increaseEnergy)) return UserGoal.sleepReset;
    return UserGoal.discipline;
  }
}

class RemoteRecommendations {
  const RemoteRecommendations({required this.habits, required this.plans});

  final List<RemoteHabitRecommendation> habits;
  final List<RemotePlanSummary> plans;
}

class RemoteHabitRecommendation {
  const RemoteHabitRecommendation({
    required this.key,
    required this.title,
    required this.description,
  });

  final String key;
  final String title;
  final String description;

  factory RemoteHabitRecommendation.fromMap(Map<String, dynamic> map) {
    return RemoteHabitRecommendation(
      key: map['key'] as String,
      title: map['title'] as String,
      description: (map['description'] as String?) ?? '',
    );
  }
}

class RemotePlanSummary {
  const RemotePlanSummary({
    required this.id,
    required this.name,
    required this.goal,
    required this.level,
    required this.sexVariant,
    required this.equipment,
    required this.daysPerWeek,
    required this.durationWeeks,
    required this.description,
    required this.tags,
    required this.highlights,
    this.heroImage,
    this.matchScore,
  });

  final String id;
  final String name;
  final PlanGoal goal;
  final PlanLevel level;
  final SexVariant sexVariant;
  final EquipmentType equipment;
  final int daysPerWeek;
  final int durationWeeks;
  final String description;
  final List<String> tags;
  final List<String> highlights;
  final String? heroImage;
  final int? matchScore;

  WorkoutPlanModel toLocalModel() {
    return WorkoutPlanModel(
      id: id,
      name: name,
      goal: goal,
      level: level,
      sexVariant: sexVariant,
      daysPerWeek: daysPerWeek,
      durationWeeks: durationWeeks,
      equipment: equipment,
      description: description,
      tags: tags,
    );
  }

  factory RemotePlanSummary.fromMap(Map<String, dynamic> map) {
    return RemotePlanSummary(
      id: map['plan_id'] as String,
      name: map['name'] as String,
      goal: _goalFromString(map['goal'] as String? ?? 'strength'),
      level: _levelFromString(map['level'] as String? ?? 'beginner'),
      sexVariant: _sexFromString(map['sex_variant'] as String? ?? 'unisex'),
      equipment: _equipmentFromString(map['equipment'] as String? ?? 'home'),
      daysPerWeek: (map['days_per_week'] as num?)?.toInt() ?? 3,
      durationWeeks: (map['duration_weeks'] as num?)?.toInt() ?? 4,
      description: (map['description'] as String?) ?? '',
      tags: (map['tags'] as List? ?? const []).map((item) => '$item').toList(),
      highlights: (map['highlights'] as List? ?? const []).map((item) => '$item').toList(),
      heroImage: map['hero_image'] as String?,
      matchScore: (map['match_score'] as num?)?.toInt(),
    );
  }
}

class RemotePlanDetail extends RemotePlanSummary {
  const RemotePlanDetail({
    required super.id,
    required super.name,
    required super.goal,
    required super.level,
    required super.sexVariant,
    required super.equipment,
    required super.daysPerWeek,
    required super.durationWeeks,
    required super.description,
    required super.tags,
    required super.highlights,
    super.heroImage,
    super.matchScore,
    required this.days,
  });

  final List<RemotePlanDay> days;

  factory RemotePlanDetail.fromMap(Map<String, dynamic> map) {
    final base = RemotePlanSummary.fromMap(map);
    return RemotePlanDetail(
      id: base.id,
      name: base.name,
      goal: base.goal,
      level: base.level,
      sexVariant: base.sexVariant,
      equipment: base.equipment,
      daysPerWeek: base.daysPerWeek,
      durationWeeks: base.durationWeeks,
      description: base.description,
      tags: base.tags,
      highlights: base.highlights,
      heroImage: base.heroImage,
      matchScore: base.matchScore,
      days: (map['days'] as List? ?? const [])
          .map((item) => RemotePlanDay.fromMap(Map<String, dynamic>.from(item as Map)))
          .toList(),
    );
  }
}

class RemotePlanDay {
  const RemotePlanDay({
    required this.id,
    required this.dayIndex,
    required this.title,
    required this.focus,
    required this.exercises,
  });

  final String id;
  final int dayIndex;
  final String title;
  final String focus;
  final List<RemoteExerciseDetail> exercises;

  factory RemotePlanDay.fromMap(Map<String, dynamic> map) {
    return RemotePlanDay(
      id: map['day_id'] as String,
      dayIndex: (map['day_index'] as num?)?.toInt() ?? 1,
      title: map['title'] as String,
      focus: (map['focus'] as String?) ?? '',
      exercises: (map['exercises'] as List? ?? const [])
          .map((item) => RemoteExerciseDetail.fromMap(Map<String, dynamic>.from(item as Map)))
          .toList(),
    );
  }
}

class RemoteExerciseDetail {
  const RemoteExerciseDetail({
    required this.id,
    required this.name,
    required this.sets,
    required this.reps,
    required this.restSeconds,
    required this.instructions,
    required this.equipment,
    this.videoUrl,
  });

  final String id;
  final String name;
  final int sets;
  final String reps;
  final int restSeconds;
  final String instructions;
  final EquipmentType equipment;
  final String? videoUrl;

  List<String> get primaryMuscles => <String>[(instructions.toLowerCase().contains('core') ? 'core' : equipment.name)];
  String get weightType => equipment == EquipmentType.gym ? 'barbell' : 'bodyweight';

  factory RemoteExerciseDetail.fromMap(Map<String, dynamic> map) {
    return RemoteExerciseDetail(
      id: map['exercise_id'] as String,
      name: map['name'] as String,
      sets: (map['sets'] as num?)?.toInt() ?? 3,
      reps: (map['reps'] as String?) ?? '10',
      restSeconds: (map['rest_seconds'] as num?)?.toInt() ?? 30,
      instructions: (map['instructions'] as String?) ?? '',
      equipment: _equipmentFromString(map['equipment'] as String? ?? 'home'),
      videoUrl: map['video_url'] as String?,
    );
  }
}

PlanGoal _goalFromString(String value) {
  switch (value) {
    case 'fatloss':
      return PlanGoal.fatloss;
    case 'mobility':
      return PlanGoal.mobility;
    default:
      return PlanGoal.strength;
  }
}

PlanLevel _levelFromString(String value) {
  switch (value) {
    case 'intermediate':
      return PlanLevel.intermediate;
    case 'advanced':
      return PlanLevel.advanced;
    default:
      return PlanLevel.beginner;
  }
}

SexVariant _sexFromString(String value) {
  switch (value) {
    case 'male':
      return SexVariant.male;
    case 'female':
      return SexVariant.female;
    default:
      return SexVariant.unisex;
  }
}

EquipmentType _equipmentFromString(String value) {
  switch (value) {
    case 'none':
      return EquipmentType.none;
    case 'gym':
      return EquipmentType.gym;
    default:
      return EquipmentType.home;
  }
}
