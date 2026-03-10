import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitz/core/database/database_provider.dart';
import 'package:habitz/core/utils/id_generator.dart';
import 'package:habitz/features/plans/domain/workout_models.dart';
import 'package:habitz/features/profile/domain/user_profile.dart';

class PlanFilter {
  const PlanFilter({
    this.sexVariant,
    this.goal,
    this.level,
    this.equipment,
    this.daysPerWeek,
    this.durationWeeks,
  });

  final SexVariant? sexVariant;
  final PlanGoal? goal;
  final PlanLevel? level;
  final EquipmentType? equipment;
  final int? daysPerWeek;
  final int? durationWeeks;

  PlanFilter copyWith({
    SexVariant? sexVariant,
    PlanGoal? goal,
    PlanLevel? level,
    EquipmentType? equipment,
    int? daysPerWeek,
    int? durationWeeks,
  }) {
    return PlanFilter(
      sexVariant: sexVariant ?? this.sexVariant,
      goal: goal ?? this.goal,
      level: level ?? this.level,
      equipment: equipment ?? this.equipment,
      daysPerWeek: daysPerWeek ?? this.daysPerWeek,
      durationWeeks: durationWeeks ?? this.durationWeeks,
    );
  }
}

final planFilterProvider = StateProvider<PlanFilter>((ref) => const PlanFilter());

final plansProvider = StreamProvider<List<WorkoutPlanModel>>((ref) {
  final filter = ref.watch(planFilterProvider);
  return ref.watch(plansRepositoryProvider).watchPlans(
        sexVariant: filter.sexVariant,
        goal: filter.goal,
        level: filter.level,
        equipment: filter.equipment,
        daysPerWeek: filter.daysPerWeek,
        durationWeeks: filter.durationWeeks,
      );
});

final planDaysProvider = StreamProvider.family<List<WorkoutDayModel>, String>((ref, planId) {
  return ref.watch(plansRepositoryProvider).watchDaysForPlan(planId);
});

final planSetsProvider = StreamProvider.family<List<WorkoutSetModel>, String>((ref, dayId) {
  return ref.watch(plansRepositoryProvider).watchSetsForDay(dayId);
});

final activePlanIdProvider = FutureProvider<String?>((ref) {
  return ref.watch(plansRepositoryProvider).getActivePlanId();
});

final plansControllerProvider = Provider<PlansController>((ref) => PlansController(ref));

class PlansController {
  PlansController(this._ref);
  final Ref _ref;

  Future<void> startPlan(String planId) {
    return _ref.read(plansRepositoryProvider).setActivePlan(planId);
  }

  Future<void> logWorkoutSession({
    required String planId,
    required String dayId,
    required int totalTime,
    required int effort,
    int completedExercises = 0,
    String? note,
  }) {
    final now = DateTime.now();
    return _ref.read(plansRepositoryProvider).logWorkoutSession(
          WorkoutSessionLogModel(
            id: IdGenerator.deterministic('workoutLog', [planId, dayId, now.toIso8601String()]),
            planId: planId,
            workoutDayId: dayId,
            date: now,
            completed: true,
            totalTime: totalTime,
            perceivedEffort: effort,
            completedExercises: completedExercises,
            note: note,
          ),
        );
  }
}
