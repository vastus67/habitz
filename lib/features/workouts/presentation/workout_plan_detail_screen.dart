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
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
                children: [
                  NeoCard(
                    padding: EdgeInsets.zero,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                          child: SizedBox(
                            height: 190,
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                SvgPicture.asset(plan.heroAsset, fit: BoxFit.cover),
                                const DecoratedBox(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [Color(0x1A000000), Color(0xC10B0F0C)],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 18,
                                  bottom: 18,
                                  right: 18,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(plan.name, style: Theme.of(context).textTheme.headlineMedium),
                                      const SizedBox(height: 6),
                                      Text(
                                        '${plan.goal.name.toUpperCase()} • ${plan.level.name.toUpperCase()} • ${plan.equipment.name.toUpperCase()}',
                                        style: const TextStyle(
                                          color: AppTheme.textPrimary,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 11,
                                          letterSpacing: 1.0,
                                        ),
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
                          child: Text(plan.description),
                        ),
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
