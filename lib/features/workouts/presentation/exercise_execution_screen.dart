import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:habitz/core/database/database_provider.dart';
import 'package:habitz/features/plans/domain/workout_models.dart';
import 'package:habitz/features/workouts/presentation/workout_summary_screen.dart';
import 'package:habitz/features/workouts/providers/workout_session_provider.dart';
import 'package:habitz/shared/widgets/neo_card.dart';
import 'package:habitz/shared/widgets/progress_ring.dart';
import 'package:habitz/theme/app_theme.dart';

class ExerciseExecutionScreen extends ConsumerStatefulWidget {
  const ExerciseExecutionScreen({
    super.key,
    required this.planId,
    required this.dayId,
    required this.exerciseIndex,
  });

  final String planId;
  final String dayId;
  final int exerciseIndex;

  @override
  ConsumerState<ExerciseExecutionScreen> createState() => _ExerciseExecutionScreenState();
}

class _ExerciseExecutionScreenState extends ConsumerState<ExerciseExecutionScreen> {
  Timer? _timer;
  int _restRemaining = 0;
  late final TextEditingController _repsController;
  late final TextEditingController _weightController;

  @override
  void initState() {
    super.initState();
    _repsController = TextEditingController();
    _weightController = TextEditingController(text: '0');
  }

  @override
  void dispose() {
    _timer?.cancel();
    _repsController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_ExecutionBundle?>(
      future: _bundle(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        final bundle = snapshot.data;
        if (bundle == null || bundle.sets.isEmpty) {
          return const Scaffold(body: Center(child: Text('No exercises found')));
        }

        final idx = widget.exerciseIndex.clamp(0, bundle.sets.length - 1);
        final workoutExercise = bundle.sets[idx];
        final exercise = bundle.exercises[workoutExercise.exerciseId];
        final progress = ref.watch(workoutSessionProvider).exerciseProgress;

        if (_repsController.text.isEmpty) {
          _repsController.text = workoutExercise.reps;
        }

        final setProgress = ((progress?.completedSets ?? 0) / workoutExercise.sets).clamp(0, 1).toDouble();

        return Scaffold(
          appBar: AppBar(title: const Text('Exercise Execution')),
          body: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: NeoCard(
                  key: ValueKey(workoutExercise.id),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppTheme.cardSoft,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          'Exercise ${idx + 1} of ${bundle.sets.length}',
                          style: const TextStyle(
                            color: AppTheme.accent,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(exercise?.name ?? 'Exercise', style: Theme.of(context).textTheme.headlineSmall),
                      const SizedBox(height: 8),
                      Container(
                        height: 160,
                        decoration: BoxDecoration(
                          color: AppTheme.cardSoft,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        alignment: Alignment.center,
                        child: Icon(Icons.ondemand_video, color: AppTheme.accent.withValues(alpha: 0.85), size: 42),
                      ),
                      const SizedBox(height: 8),
                      Text(exercise?.instructions ?? 'Follow strict form and controlled tempo.'),
                      const SizedBox(height: 8),
                      Text('${workoutExercise.sets} sets x ${workoutExercise.reps} reps • Rest ${workoutExercise.restSeconds}s'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Center(child: ProgressRing(progress: setProgress, label: 'Set ${progress?.currentSet ?? 1} of ${workoutExercise.sets}')),
              const SizedBox(height: 12),
              NeoCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _repsController,
                      decoration: const InputDecoration(labelText: 'Adjust reps'),
                      onChanged: (value) => ref.read(workoutSessionProvider.notifier).updateTargetReps(value),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _weightController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Adjust weight (kg)'),
                      onChanged: (value) =>
                          ref.read(workoutSessionProvider.notifier).updateWeight(double.tryParse(value) ?? 0),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Rest timer: ${_restRemaining}s',
                      style: const TextStyle(color: AppTheme.textSecondary),
                    ),
                    const SizedBox(height: 8),
                    OutlinedButton(
                      onPressed: _restRemaining > 0 ? null : () => _startRest(workoutExercise.restSeconds),
                      child: const Text('Start rest timer'),
                    ),
                    const SizedBox(height: 8),
                    FilledButton(
                      onPressed: () => ref.read(workoutSessionProvider.notifier).completeSet(),
                      child: const Text('Mark set completed'),
                    ),
                  ],
                ),
              ),
            ],
          ),
          bottomNavigationBar: SafeArea(
            minimum: const EdgeInsets.all(20),
            child: FilledButton(
              style: FilledButton.styleFrom(backgroundColor: AppTheme.accent, foregroundColor: Colors.black),
              onPressed: () {
                if (idx + 1 < bundle.sets.length) {
                  ref.read(workoutSessionProvider.notifier).moveToExercise(idx + 1, bundle.sets[idx + 1]);
                  context.go('/exercise/${widget.planId}/${widget.dayId}/${idx + 1}');
                  return;
                }
                context.push('/workout-summary',
                    extra: WorkoutSummaryArgs(
                      planId: widget.planId,
                      workoutDayId: widget.dayId,
                      exercisesCompleted: bundle.sets.length,
                    ));
              },
              child: Text(idx + 1 < bundle.sets.length ? 'Next Exercise' : 'Finish Workout'),
            ),
          ),
        );
      },
    );
  }

  Future<_ExecutionBundle?> _bundle() async {
    final repo = ref.read(plansRepositoryProvider);
    final sets = await repo.getSetsForDay(widget.dayId);
    if (sets.isEmpty) return null;

    final exercises = <String, ExerciseModel>{};
    for (final set in sets) {
      final exercise = await repo.getExercise(set.exerciseId);
      if (exercise != null) exercises[exercise.id] = exercise;
    }
    return _ExecutionBundle(sets: sets, exercises: exercises);
  }

  void _startRest(int seconds) {
    _timer?.cancel();
    setState(() => _restRemaining = seconds);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_restRemaining <= 0) {
        timer.cancel();
        return;
      }
      setState(() => _restRemaining--);
    });
  }
}

class _ExecutionBundle {
  const _ExecutionBundle({required this.sets, required this.exercises});

  final List<WorkoutSetModel> sets;
  final Map<String, ExerciseModel> exercises;
}
