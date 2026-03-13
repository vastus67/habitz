import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:habitz/features/dashboard/providers/dashboard_provider.dart';
import 'package:habitz/features/habits/providers/habits_provider.dart';
import 'package:habitz/features/plans/providers/plans_provider.dart';
import 'package:habitz/features/workouts/providers/workout_session_provider.dart';
import 'package:habitz/shared/widgets/neo_card.dart';
import 'package:habitz/shared/widgets/progress_ring.dart';
import 'package:habitz/theme/app_theme.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref.watch(dashboardProvider);
    final activePlanId = ref.watch(activePlanIdProvider);
    final sessionState = ref.watch(workoutSessionProvider);
    final habits = ref.watch(habitsProvider).valueOrNull ?? const [];

    return Scaffold(
      appBar: AppBar(title: const Text('Today')),
      body: snapshot.when(
        data: (data) => ListView(
          padding: const EdgeInsets.all(20),
          children: [
            NeoCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'SYSTEM LIVE',
                    style: TextStyle(
                      color: AppTheme.accent,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.1,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Build momentum before the day gets away from you.',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    data.adaptiveMessage,
                    style: const TextStyle(color: AppTheme.textSecondary, height: 1.5),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(
                        child: Center(
                          child: ProgressRing(
                            progress: data.completion,
                            label: 'Daily Completion',
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          children: [
                            _MetricTile(label: 'Score', value: '${data.score.dailyScore}'),
                            const SizedBox(height: 12),
                            _MetricTile(label: 'Streak', value: '${data.streak}d'),
                            const SizedBox(height: 12),
                            _MetricTile(
                              label: 'Momentum',
                              value: data.score.momentum.toStringAsFixed(2),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            activePlanId.when(
              data: (planId) => _todayWorkoutCard(context, ref, planId, sessionState),
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
            ),
            const SizedBox(height: 12),
            NeoCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Habit board',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      TextButton(
                        onPressed: () => context.go('/habits'),
                        child: const Text('Open'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      if (habits.isEmpty)
                        const Text(
                          'Complete onboarding habits to populate this board.',
                          style: TextStyle(color: AppTheme.textSecondary),
                        ),
                      for (final habit in habits.take(4))
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: AppTheme.cardSoft,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Text(
                            habit.title,
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
      ),
    );
  }

  Widget _todayWorkoutCard(
    BuildContext context,
    WidgetRef ref,
    String? planId,
    ActiveWorkoutSessionState sessionState,
  ) {
    if (planId == null) {
      return NeoCard(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Expanded(
              child: Text('Today\'s Workout', style: TextStyle(fontWeight: FontWeight.w600)),
            ),
            OutlinedButton(
              onPressed: () => context.go('/plans'),
              child: const Text('Select Plan'),
            ),
          ],
        ),
      );
    }

    final planProgress = ref.watch(weeklyPlanProgressProvider(planId));
    return NeoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Today\'s Workout',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
          ),
          const SizedBox(height: 8),
          planProgress.when(
            data: (value) => Text(
              'Week progress ${(value * 100).round()}%',
              style: const TextStyle(color: AppTheme.textSecondary),
            ),
            loading: () => const Text('Loading progress...'),
            error: (_, __) => const SizedBox.shrink(),
          ),
          const SizedBox(height: 8),
          Container(
            height: 10,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(999),
              color: AppTheme.cardSoft,
            ),
            child: planProgress.when(
              data: (value) => FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: value.clamp(0, 1),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(999),
                    color: AppTheme.accent,
                  ),
                ),
              ),
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
            ),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: AppTheme.accent,
                foregroundColor: Colors.black,
              ),
              onPressed: () async {
                final day = sessionState.currentWorkoutDay;
                if (day != null && day.planId == planId) {
                  final progress = sessionState.exerciseProgress?.exerciseIndex ?? 0;
                  context.push('/exercise/$planId/${day.id}/$progress');
                  return;
                }
                final days = await ref.read(planDaysProvider(planId).future);
                if (context.mounted && days.isNotEmpty) {
                  context.push('/workout-day/$planId/${days.first.id}');
                }
              },
              child: Text(sessionState.currentWorkoutDay?.planId == planId ? 'Resume' : 'Start'),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
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
          Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}
