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

class WorkoutSummaryScreen extends ConsumerStatefulWidget {
  const WorkoutSummaryScreen({super.key, this.args});

  final WorkoutSummaryArgs? args;

  @override
  ConsumerState<WorkoutSummaryScreen> createState() => _WorkoutSummaryScreenState();
}

class _WorkoutSummaryScreenState extends ConsumerState<WorkoutSummaryScreen> {
  late final TextEditingController _noteController;
  double _effort = 7;

  @override
  void initState() {
    super.initState();
    _noteController = TextEditingController();
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activeState = ref.watch(workoutSessionProvider);
    final fallbackExercises = activeState.exerciseProgress?.exerciseIndex ?? 0;
    final completedExercises = widget.args?.exercisesCompleted ?? fallbackExercises;
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
                const Text(
                  'SESSION COMPLETE',
                  style: TextStyle(
                    color: AppTheme.accent,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.1,
                  ),
                ),
                const SizedBox(height: 10),
                Text('Workout completed', style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(child: _SummaryMetric(label: 'Exercises', value: '$completedExercises')),
                    const SizedBox(width: 10),
                    Expanded(child: _SummaryMetric(label: 'Duration', value: '$duration min')),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(child: _SummaryMetric(label: 'Calories', value: '$calories kcal')),
                    const SizedBox(width: 10),
                    Expanded(child: _SummaryMetric(label: 'XP', value: '$xp')),
                  ],
                ),
                const SizedBox(height: 16),
                Text('How hard was it?', style: Theme.of(context).textTheme.titleMedium),
                Slider(
                  min: 1,
                  max: 10,
                  divisions: 9,
                  activeColor: AppTheme.accent,
                  value: _effort,
                  label: _effort.round().toString(),
                  onChanged: (value) => setState(() => _effort = value),
                ),
                TextField(
                  controller: _noteController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Quick note',
                    hintText: 'Felt strong, added weight, tough finisher...'
                  ),
                ),
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
              onPressed: widget.args == null
                  ? null
                  : () async {
                      await ref.read(workoutSessionProvider.notifier).completeWorkout(
                            planId: widget.args!.planId,
                            workoutDayId: widget.args!.workoutDayId,
                            completedExercises: widget.args!.exercisesCompleted,
                            effort: _effort.round(),
                            note: _noteController.text.trim().isEmpty ? null : _noteController.text.trim(),
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

class _SummaryMetric extends StatelessWidget {
  const _SummaryMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.cardSoft,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
          const SizedBox(height: 6),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 20)),
        ],
      ),
    );
  }
}
