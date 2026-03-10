import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitz/core/database/database_provider.dart';
import 'package:habitz/core/utils/id_generator.dart';
import 'package:habitz/features/plans/domain/workout_models.dart';
import 'package:habitz/features/plans/providers/plans_provider.dart';

class ExerciseProgressState {
  const ExerciseProgressState({
    required this.exerciseIndex,
    required this.currentSet,
    required this.totalSets,
    required this.completedSets,
    this.targetReps,
    this.weight = 0,
  });

  final int exerciseIndex;
  final int currentSet;
  final int totalSets;
  final int completedSets;
  final String? targetReps;
  final double weight;

  ExerciseProgressState copyWith({
    int? exerciseIndex,
    int? currentSet,
    int? totalSets,
    int? completedSets,
    String? targetReps,
    double? weight,
  }) {
    return ExerciseProgressState(
      exerciseIndex: exerciseIndex ?? this.exerciseIndex,
      currentSet: currentSet ?? this.currentSet,
      totalSets: totalSets ?? this.totalSets,
      completedSets: completedSets ?? this.completedSets,
      targetReps: targetReps ?? this.targetReps,
      weight: weight ?? this.weight,
    );
  }
}

class ActiveWorkoutSessionState {
  const ActiveWorkoutSessionState({
    this.activeWorkoutPlan,
    this.currentWorkoutDay,
    this.exerciseProgress,
    this.workoutHistory = const [],
    this.workoutStart,
  });

  final WorkoutPlanModel? activeWorkoutPlan;
  final WorkoutDayModel? currentWorkoutDay;
  final ExerciseProgressState? exerciseProgress;
  final List<WorkoutHistoryModel> workoutHistory;
  final DateTime? workoutStart;

  ActiveWorkoutSessionState copyWith({
    WorkoutPlanModel? activeWorkoutPlan,
    WorkoutDayModel? currentWorkoutDay,
    ExerciseProgressState? exerciseProgress,
    List<WorkoutHistoryModel>? workoutHistory,
    DateTime? workoutStart,
    bool clearPlan = false,
    bool clearDay = false,
    bool clearProgress = false,
  }) {
    return ActiveWorkoutSessionState(
      activeWorkoutPlan: clearPlan ? null : (activeWorkoutPlan ?? this.activeWorkoutPlan),
      currentWorkoutDay: clearDay ? null : (currentWorkoutDay ?? this.currentWorkoutDay),
      exerciseProgress: clearProgress ? null : (exerciseProgress ?? this.exerciseProgress),
      workoutHistory: workoutHistory ?? this.workoutHistory,
      workoutStart: workoutStart ?? this.workoutStart,
    );
  }
}

final workoutSessionProvider = StateNotifierProvider<WorkoutSessionController, ActiveWorkoutSessionState>(
  (ref) => WorkoutSessionController(ref),
);

final workoutHistoryProvider = FutureProvider<List<WorkoutHistoryModel>>((ref) async {
  return ref.watch(plansRepositoryProvider).getWorkoutHistory();
});

final workoutStreakProvider = FutureProvider<int>((ref) async {
  return ref.watch(plansRepositoryProvider).workoutStreakDays();
});

final weeklyPlanProgressProvider = FutureProvider.family<double, String>((ref, planId) async {
  return ref.watch(plansRepositoryProvider).weeklyProgressForPlan(planId);
});

class WorkoutSessionController extends StateNotifier<ActiveWorkoutSessionState> {
  WorkoutSessionController(this._ref) : super(const ActiveWorkoutSessionState()) {
    _loadHistory();
  }

  final Ref _ref;

  Future<void> _loadHistory() async {
    final history = await _ref.read(plansRepositoryProvider).getWorkoutHistory();
    state = state.copyWith(workoutHistory: history);
  }

  Future<void> startPlan(String planId) async {
    await _ref.read(plansRepositoryProvider).setActivePlan(planId);
    _ref.invalidate(activePlanIdProvider);
    final plan = await _ref.read(plansRepositoryProvider).getPlan(planId);
    state = state.copyWith(activeWorkoutPlan: plan);
  }

  Future<void> beginWorkoutDay({
    required WorkoutPlanModel plan,
    required WorkoutDayModel day,
    required WorkoutSetModel firstExercise,
  }) async {
    state = state.copyWith(
      activeWorkoutPlan: plan,
      currentWorkoutDay: day,
      workoutStart: DateTime.now(),
      exerciseProgress: ExerciseProgressState(
        exerciseIndex: 0,
        currentSet: 1,
        totalSets: firstExercise.sets,
        completedSets: 0,
        targetReps: firstExercise.reps,
      ),
    );
  }

  void moveToExercise(int exerciseIndex, WorkoutSetModel exercise) {
    state = state.copyWith(
      exerciseProgress: ExerciseProgressState(
        exerciseIndex: exerciseIndex,
        currentSet: 1,
        totalSets: exercise.sets,
        completedSets: 0,
        targetReps: exercise.reps,
      ),
    );
  }

  void completeSet() {
    final progress = state.exerciseProgress;
    if (progress == null) return;

    final completed = (progress.completedSets + 1).clamp(0, progress.totalSets);
    final nextSet = (progress.currentSet + 1).clamp(1, progress.totalSets);
    state = state.copyWith(
      exerciseProgress: progress.copyWith(
        completedSets: completed,
        currentSet: nextSet,
      ),
    );
  }

  void updateWeight(double value) {
    final progress = state.exerciseProgress;
    if (progress == null) return;
    state = state.copyWith(exerciseProgress: progress.copyWith(weight: value));
  }

  void updateTargetReps(String reps) {
    final progress = state.exerciseProgress;
    if (progress == null) return;
    state = state.copyWith(exerciseProgress: progress.copyWith(targetReps: reps));
  }

  Future<WorkoutHistoryModel> completeWorkout({
    required String planId,
    required String workoutDayId,
    required int completedExercises,
  }) async {
    final started = state.workoutStart ?? DateTime.now();
    final duration = DateTime.now().difference(started).inMinutes.clamp(1, 300);

    final log = WorkoutSessionLogModel(
      id: IdGenerator.deterministic('workoutLog', [planId, workoutDayId, DateTime.now().toIso8601String()]),
      planId: planId,
      workoutDayId: workoutDayId,
      date: DateTime.now(),
      completed: true,
      totalTime: duration,
      perceivedEffort: 7,
      completedExercises: completedExercises,
    );

    await _ref.read(plansRepositoryProvider).logWorkoutSession(log);
    final historyEntry = WorkoutHistoryModel(
      date: log.date,
      planId: planId,
      workoutDayId: workoutDayId,
      duration: duration,
      completedExercises: completedExercises,
    );

    state = state.copyWith(
      workoutHistory: [historyEntry, ...state.workoutHistory],
      clearDay: true,
      clearProgress: true,
    );
    _ref.invalidate(workoutHistoryProvider);
    _ref.invalidate(workoutStreakProvider);
    _ref.invalidate(weeklyPlanProgressProvider(planId));
    return historyEntry;
  }
}
