import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:habitz/core/database/database_provider.dart';
import 'package:habitz/features/plans/domain/workout_models.dart';
import 'package:habitz/features/plans/providers/plans_provider.dart';
import 'package:habitz/features/workouts/providers/workout_session_provider.dart';
import 'package:habitz/shared/widgets/neo_card.dart';
import 'package:habitz/theme/app_theme.dart';

class WorkoutDayScreen extends ConsumerWidget {
  const WorkoutDayScreen({
    super.key,
    required this.planId,
    required this.dayId,
  });

  final String planId;
  final String dayId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Workout Day')),
      body: FutureBuilder<_WorkoutDayBundle?>(
        future: _bundle(ref),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final bundle = snapshot.data;
          if (bundle == null) {
            return const Center(child: Text('Workout day unavailable'));
          }

          final estimatedMinutes = bundle.sets.fold<int>(0, (value, item) => value + item.sets * 3);

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              NeoCard(
                padding: EdgeInsets.zero,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                      child: SizedBox(
                        height: 170,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            SvgPicture.asset(bundle.plan.heroAsset, fit: BoxFit.cover),
                            const DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [Color(0x12000000), Color(0xB20A0F0B)],
                                ),
                              ),
                            ),
                            Positioned(
                              left: 18,
                              right: 18,
                              bottom: 18,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(bundle.day.title, style: Theme.of(context).textTheme.headlineMedium),
                                  const SizedBox(height: 6),
                                  Text(
                                    '${bundle.plan.name} • ${bundle.sets.length} exercises',
                                    style: const TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(18),
                      child: Row(
                        children: [
                          Expanded(child: _WorkoutMeta(label: 'Estimated', value: '$estimatedMinutes min')),
                          const SizedBox(width: 10),
                          Expanded(child: _WorkoutMeta(label: 'Exercises', value: '${bundle.sets.length}')),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              for (var index = 0; index < bundle.sets.length; index++) ...[
                _ExerciseCard(
                  index: index,
                  set: bundle.sets[index],
                  exercise: bundle.exercises[bundle.sets[index].exerciseId],
                  onTap: () => _startWorkoutAtIndex(context, ref, bundle, index),
                ),
                const SizedBox(height: 10),
              ],
            ],
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.all(20),
        child: FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: AppTheme.accent,
            foregroundColor: Colors.black,
            minimumSize: const Size.fromHeight(52),
          ),
          onPressed: () async {
            final bundle = await _bundle(ref);
            if (bundle == null || bundle.sets.isEmpty || !context.mounted) return;
            _startWorkoutAtIndex(context, ref, bundle, 0);
          },
          child: const Text('Start Workout'),
        ),
      ),
    );
  }

  Future<_WorkoutDayBundle?> _bundle(WidgetRef ref) async {
    final repo = ref.read(plansRepositoryProvider);
    final plan = await repo.getPlan(planId);
    if (plan == null) return null;

    final days = await ref.read(planDaysProvider(planId).future);
    final dayIndex = days.indexWhere((item) => item.id == dayId);
    final day = dayIndex == -1 ? null : days[dayIndex];
    if (day == null) return null;

    final sets = await repo.getSetsForDay(dayId);
    final exercises = <String, ExerciseModel>{};
    for (final set in sets) {
      final exercise = await repo.getExercise(set.exerciseId);
      if (exercise != null) exercises[exercise.id] = exercise;
    }

    return _WorkoutDayBundle(plan: plan, day: day, sets: sets, exercises: exercises);
  }

  Future<void> _startWorkoutAtIndex(
    BuildContext context,
    WidgetRef ref,
    _WorkoutDayBundle bundle,
    int index,
  ) async {
    final firstSet = bundle.sets[index];
    await ref.read(workoutSessionProvider.notifier).beginWorkoutDay(
          plan: bundle.plan,
          day: bundle.day,
          firstExercise: firstSet,
        );
    ref.read(workoutSessionProvider.notifier).moveToExercise(index, firstSet);

    if (context.mounted) {
      context.push('/exercise/${bundle.plan.id}/${bundle.day.id}/$index');
    }
  }
}

class _WorkoutMeta extends StatelessWidget {
  const _WorkoutMeta({required this.label, required this.value});

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
          Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}

class _ExerciseCard extends StatelessWidget {
  const _ExerciseCard({
    required this.index,
    required this.set,
    required this.exercise,
    required this.onTap,
  });

  final int index;
  final WorkoutSetModel set;
  final ExerciseModel? exercise;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final group = exercise?.muscleGroup ?? 'full body';
    final icon = switch (group) {
      'legs' => Icons.directions_run,
      'core' => Icons.adjust,
      'back' => Icons.accessibility_new,
      'chest' => Icons.fitness_center,
      _ => Icons.sports_gymnastics,
    };

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: NeoCard(
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: AppTheme.cardSoft,
              child: Icon(icon, color: AppTheme.accent),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exercise?.name ?? 'Exercise ${index + 1}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text('${set.sets} sets x ${set.reps} reps'),
                  Text('Rest ${set.restSeconds}s', style: const TextStyle(color: AppTheme.textSecondary)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}

class _WorkoutDayBundle {
  const _WorkoutDayBundle({
    required this.plan,
    required this.day,
    required this.sets,
    required this.exercises,
  });

  final WorkoutPlanModel plan;
  final WorkoutDayModel day;
  final List<WorkoutSetModel> sets;
  final Map<String, ExerciseModel> exercises;
}
