import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:habitz/features/dashboard/providers/dashboard_provider.dart';
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

    return Scaffold(
      appBar: AppBar(title: const Text('Today')),
      body: snapshot.when(
        data: (data) => ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Center(
              child: ProgressRing(
                progress: data.completion,
                label: 'Daily Completion',
              ),
            ),
            const SizedBox(height: 16),
            NeoCard(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _metric('Score', '${data.score.dailyScore}'),
                  _metric('Streak', '${data.streak}d'),
                  _metric('Momentum', data.score.momentum.toStringAsFixed(2)),
                ],
              ),
            ),
            const SizedBox(height: 12),
            NeoCard(child: Text(data.adaptiveMessage)),
            const SizedBox(height: 12),
            activePlanId.when(
              data: (planId) => _todayWorkoutCard(context, ref, planId, sessionState),
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
            )
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
          const Text('Today\'s Workout', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          planProgress.when(
            data: (value) => Text('Week progress ${(value * 100).round()}%'),
            loading: () => const Text('Loading progress...'),
            error: (_, __) => const SizedBox.shrink(),
          ),
          const SizedBox(height: 8),
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

  Widget _metric(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
        const SizedBox(height: 6),
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
      ],
    );
  }
}
