import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:habitz/features/workouts/providers/workout_session_provider.dart';
import 'package:habitz/shared/widgets/neo_card.dart';
import 'package:habitz/theme/app_theme.dart';

class WorkoutSummaryArgs {
  const WorkoutSummaryArgs({
    required this.planId,
    required this.workoutDayId,
    required this.exercisesCompleted,
  });

  final String planId;
  final String workoutDayId;
  final int exercisesCompleted;
}

class WorkoutSummaryScreen extends ConsumerWidget {
  const WorkoutSummaryScreen({super.key, this.args});

  final WorkoutSummaryArgs? args;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeState = ref.watch(workoutSessionProvider);
    final fallbackExercises = activeState.exerciseProgress?.exerciseIndex ?? 0;
    final completedExercises = args?.exercisesCompleted ?? fallbackExercises;
    final started = activeState.workoutStart;
    final duration = started == null ? 25 : DateTime.now().difference(started).inMinutes.clamp(1, 300);
    final calories = (duration * 7.4).round();
    final xp = completedExercises * 15;

    return Scaffold(
      appBar: AppBar(title: const Text('Workout Summary')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          NeoCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Workout completed', style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 8),
                Text('Exercises completed: $completedExercises'),
                Text('Total duration: $duration min'),
                Text('Calories estimate: $calories kcal'),
                Text('XP gained: $xp'),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: AppTheme.accent,
                foregroundColor: Colors.black,
                minimumSize: const Size.fromHeight(52),
              ),
              onPressed: args == null
                  ? null
                  : () async {
                      await ref.read(workoutSessionProvider.notifier).completeWorkout(
                            planId: args!.planId,
                            workoutDayId: args!.workoutDayId,
                            completedExercises: args!.exercisesCompleted,
                          );
                      if (context.mounted) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(content: Text('Workout saved')));
                      }
                    },
              child: const Text('Save workout'),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () => context.go('/home'),
              child: const Text('Return to dashboard'),
            ),
          ],
        ),
      ),
    );
  }
}
