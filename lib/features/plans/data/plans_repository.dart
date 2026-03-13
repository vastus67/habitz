import 'package:drift/drift.dart';
import 'package:habitz/core/database/app_database.dart';
import 'package:habitz/features/plans/domain/workout_models.dart';
import 'package:habitz/features/profile/domain/user_profile.dart';

class PlansRepository {
  PlansRepository(this._db);

  final AppDatabase _db;

  Stream<List<WorkoutPlanModel>> watchPlans({
    SexVariant? sexVariant,
    PlanGoal? goal,
    PlanLevel? level,
    EquipmentType? equipment,
    int? daysPerWeek,
    int? durationWeeks,
  }) {
    final query = _db.select(_db.workoutPlanEntries);
    if (sexVariant != null) {
      query.where(
        (tbl) => tbl.sexVariant.equals(sexVariant.name) |
            tbl.sexVariant.equals(SexVariant.unisex.name),
      );
    }
    if (goal != null) {
      query.where((tbl) => tbl.goal.equals(goal.name));
    }
    if (level != null) {
      query.where((tbl) => tbl.level.equals(level.name));
    }
    if (equipment != null) {
      query.where((tbl) => tbl.equipment.equals(equipment.name));
    }
    if (daysPerWeek != null) {
      query.where((tbl) => tbl.daysPerWeek.equals(daysPerWeek));
    }
    if (durationWeeks != null) {
      query.where((tbl) => tbl.durationWeeks.equals(durationWeeks));
    }
    return query.watch().map(
          (rows) => rows
              .map(
                (row) => WorkoutPlanModel(
                  id: row.id,
                  name: row.name,
                  goal: PlanGoal.values.firstWhere(
                    (e) => e.name == row.goal,
                    orElse: () => PlanGoal.strength,
                  ),
                  level: PlanLevel.values.firstWhere(
                    (e) => e.name == row.level,
                    orElse: () => PlanLevel.beginner,
                  ),
                  sexVariant: SexVariant.values.firstWhere(
                    (e) => e.name == row.sexVariant,
                    orElse: () => SexVariant.unisex,
                  ),
                  daysPerWeek: row.daysPerWeek,
                  durationWeeks: row.durationWeeks,
                  equipment: EquipmentType.values.firstWhere(
                    (e) => e.name == row.equipment,
                    orElse: () => EquipmentType.home,
                  ),
                  description: row.description,
                  tags: row.tags.split(',').where((e) => e.isNotEmpty).toList(),
                ),
              )
              .toList()
            ..sort((a, b) {
              final aExact = sexVariant != null && a.sexVariant == sexVariant ? 1 : 0;
              final bExact = sexVariant != null && b.sexVariant == sexVariant ? 1 : 0;
              if (aExact != bExact) return bExact.compareTo(aExact);
              return a.name.compareTo(b.name);
            }),
        );
  }

  Future<WorkoutPlanModel?> getPlan(String planId) async {
    final row = await (_db.select(_db.workoutPlanEntries)
          ..where((tbl) => tbl.id.equals(planId)))
        .getSingleOrNull();
    if (row == null) return null;
    return WorkoutPlanModel(
      id: row.id,
      name: row.name,
      goal: PlanGoal.values.firstWhere(
        (e) => e.name == row.goal,
        orElse: () => PlanGoal.strength,
      ),
      level: PlanLevel.values.firstWhere(
        (e) => e.name == row.level,
        orElse: () => PlanLevel.beginner,
      ),
      sexVariant: SexVariant.values.firstWhere(
        (e) => e.name == row.sexVariant,
        orElse: () => SexVariant.unisex,
      ),
      daysPerWeek: row.daysPerWeek,
      durationWeeks: row.durationWeeks,
      equipment: EquipmentType.values.firstWhere(
        (e) => e.name == row.equipment,
        orElse: () => EquipmentType.home,
      ),
      description: row.description,
      tags: row.tags.split(',').where((e) => e.isNotEmpty).toList(),
    );
  }

  Stream<List<WorkoutDayModel>> watchDaysForPlan(String planId) {
    final query = _db.select(_db.workoutDayEntries)
      ..where((tbl) => tbl.planId.equals(planId))
      ..orderBy([(tbl) => OrderingTerm.asc(tbl.dayIndex)]);

    return query.watch().map((rows) {
      return rows
          .map((row) => WorkoutDayModel(
                id: row.id,
                planId: row.planId,
                dayIndex: row.dayIndex,
                title: row.title,
              ))
          .toList();
    });
  }

  Stream<List<WorkoutSetModel>> watchSetsForDay(String dayId) {
    final query = _db.select(_db.workoutSetEntries)
      ..where((tbl) => tbl.workoutDayId.equals(dayId));
    return query.watch().map(
          (rows) => rows
              .map(
                (row) => WorkoutSetModel(
                  id: row.id,
                  workoutDayId: row.workoutDayId,
                  exerciseId: row.exerciseId,
                  sets: row.sets,
                  reps: row.reps,
                  restSeconds: row.restSeconds,
                  tempo: row.tempo,
                  weightType: row.weightType,
                  progressionRule: row.progressionRule,
                ),
              )
              .toList(),
        );
  }

  Future<ExerciseModel?> getExercise(String exerciseId) async {
    final row = await (_db.select(_db.exerciseEntries)
          ..where((tbl) => tbl.id.equals(exerciseId)))
        .getSingleOrNull();
    if (row == null) return null;
    return ExerciseModel(
      id: row.id,
      name: row.name,
      primaryMuscles:
          row.primaryMuscles.split(',').where((e) => e.isNotEmpty).toList(),
      equipment: EquipmentType.values.firstWhere(
        (e) => e.name == row.equipment,
        orElse: () => EquipmentType.home,
      ),
      instructions: row.instructions,
      videoUrl: row.videoUrl,
    );
  }

  Future<void> setActivePlan(String planId) async {
    final profile = await (_db.select(_db.userProfileEntries)).getSingleOrNull();
    if (profile == null) return;
    await (_db.update(_db.userProfileEntries)..where((tbl) => tbl.id.equals(profile.id)))
        .write(UserProfileEntriesCompanion(activePlanId: Value(planId)));
  }

  Future<String?> getActivePlanId() async {
    final profile = await (_db.select(_db.userProfileEntries)).getSingleOrNull();
    return profile?.activePlanId;
  }

  Future<void> logWorkoutSession(WorkoutSessionLogModel log) async {
    final metadataNote = 'ce:${log.completedExercises}|${log.note ?? ''}';
    await _db.into(_db.workoutSessionLogEntries).insertOnConflictUpdate(
          WorkoutSessionLogEntriesCompanion.insert(
            id: log.id,
            planId: log.planId,
            workoutDayId: log.workoutDayId,
            date: log.date,
            completed: Value(log.completed),
            totalTime: Value(log.totalTime),
            perceivedEffort: Value(log.perceivedEffort),
            note: Value(metadataNote),
          ),
        );
  }

  Future<List<WorkoutSetModel>> getSetsForDay(String dayId) async {
    final rows = await (_db.select(_db.workoutSetEntries)
          ..where((tbl) => tbl.workoutDayId.equals(dayId)))
        .get();
    return rows
        .map(
          (row) => WorkoutSetModel(
            id: row.id,
            workoutDayId: row.workoutDayId,
            exerciseId: row.exerciseId,
            sets: row.sets,
            reps: row.reps,
            restSeconds: row.restSeconds,
            tempo: row.tempo,
            weightType: row.weightType,
            progressionRule: row.progressionRule,
          ),
        )
        .toList();
  }

  Future<List<WorkoutHistoryModel>> getWorkoutHistory({String? planId}) async {
    final query = _db.select(_db.workoutSessionLogEntries)
      ..orderBy([(tbl) => OrderingTerm.desc(tbl.date)]);
    if (planId != null) {
      query.where((tbl) => tbl.planId.equals(planId));
    }

    final rows = await query.get();
    return rows
        .map(
          (row) => WorkoutHistoryModel(
            date: row.date,
            planId: row.planId,
            workoutDayId: row.workoutDayId,
            duration: row.totalTime,
            completedExercises: _parseCompletedExercises(row.note),
          ),
        )
        .toList();
  }

  Future<int> workoutStreakDays() async {
    final rows = await (_db.select(_db.workoutSessionLogEntries)
          ..where((tbl) => tbl.completed.equals(true))
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.date)]))
        .get();
    if (rows.isEmpty) return 0;

    final uniqueDays = rows
        .map((entry) => DateTime(entry.date.year, entry.date.month, entry.date.day))
        .toSet()
        .toList()
      ..sort((a, b) => b.compareTo(a));

    var streak = 0;
    DateTime? expected;
    for (final day in uniqueDays) {
      if (expected == null) {
        final today = DateTime.now();
        final normalizedToday = DateTime(today.year, today.month, today.day);
        final yesterday = normalizedToday.subtract(const Duration(days: 1));
        if (day != normalizedToday && day != yesterday) break;
        streak = 1;
        expected = day.subtract(const Duration(days: 1));
        continue;
      }

      if (day == expected) {
        streak++;
        expected = day.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }
    return streak;
  }

  Future<double> weeklyProgressForPlan(String planId) async {
    final plan = await getPlan(planId);
    if (plan == null || plan.daysPerWeek <= 0) return 0;

    final now = DateTime.now();
    final weekStart = DateTime(now.year, now.month, now.day)
        .subtract(Duration(days: now.weekday - 1));
    final sessions = await (_db.select(_db.workoutSessionLogEntries)
          ..where((tbl) => tbl.planId.equals(planId))
          ..where((tbl) => tbl.date.isBiggerOrEqualValue(weekStart))
          ..where((tbl) => tbl.completed.equals(true)))
        .get();

    return (sessions.length / plan.daysPerWeek).clamp(0, 1).toDouble();
  }

  Future<double> weeklyAdherence() async {
    final now = DateTime.now();
    final start = now.subtract(const Duration(days: 7));
    final sessions = await (_db.select(_db.workoutSessionLogEntries)
          ..where((tbl) => tbl.date.isBiggerOrEqualValue(start)))
        .get();
    if (sessions.isEmpty) return 0;
    final completed = sessions.where((e) => e.completed).length;
    return completed / sessions.length;
  }

  int _parseCompletedExercises(String? note) {
    if (note == null || !note.startsWith('ce:')) return 0;
    final pipe = note.indexOf('|');
    final raw = pipe == -1 ? note.substring(3) : note.substring(3, pipe);
    return int.tryParse(raw) ?? 0;
  }
}
