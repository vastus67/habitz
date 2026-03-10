import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:habitz/core/database/database_provider.dart';
import 'package:habitz/features/plans/domain/workout_models.dart';
import 'package:habitz/features/plans/providers/plans_provider.dart';
import 'package:habitz/features/workouts/providers/workout_session_provider.dart';
import 'package:habitz/shared/widgets/neo_card.dart';
import 'package:habitz/theme/app_theme.dart';

class WorkoutPlanDetailScreen extends ConsumerWidget {
  const WorkoutPlanDetailScreen({super.key, required this.planId});

  final String planId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final daysAsync = ref.watch(planDaysProvider(planId));

    return Scaffold(
      appBar: AppBar(title: const Text('Plan Detail')),
      body: FutureBuilder(
        future: ref.read(plansRepositoryProvider).getPlan(planId),
        builder: (context, snapshot) {
          final plan = snapshot.data;
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (plan == null) {
            return const Center(child: Text('Plan not found'));
          }

          return daysAsync.when(
            data: (days) {
              final grouped = <int, List<WorkoutDayModel>>{};
              for (final day in days) {
                final week = ((day.dayIndex - 1) ~/ plan.daysPerWeek) + 1;
                grouped.putIfAbsent(week, () => []).add(day);
              }

              return ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  NeoCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(plan.name, style: Theme.of(context).textTheme.headlineMedium),
                        const SizedBox(height: 8),
                        Text(plan.description),
                        const SizedBox(height: 10),
                        Text('Difficulty: ${plan.difficulty}'),
                        Text('Goal: ${plan.goal.name.toUpperCase()}'),
                        Text('Equipment: ${plan.equipment.name}'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  NeoCard(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _stat('Duration', '${plan.durationWeeks}w'),
                        _stat('Days/week', '${plan.daysPerWeek}'),
                        _stat('Workouts', '${days.length}'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: AppTheme.accent,
                      foregroundColor: Colors.black,
                    ),
                    onPressed: () async {
                      await ref.read(workoutSessionProvider.notifier).startPlan(plan.id);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Plan started')),
                        );
                      }
                    },
                    child: const Text('Start Plan'),
                  ),
                  const SizedBox(height: 16),
                  for (final entry in grouped.entries) ...[
                    Text('Week ${entry.key}', style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 8),
                    for (final day in entry.value)
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text('Day ${day.dayIndex} ${day.title}'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => context.push('/workout-day/${plan.id}/${day.id}'),
                      ),
                    const SizedBox(height: 12),
                  ],
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Center(child: Text(error.toString())),
          );
        },
      ),
    );
  }

  Widget _stat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
      ],
    );
  }
}
