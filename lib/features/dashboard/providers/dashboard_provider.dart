import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitz/core/database/database_provider.dart';
import 'package:habitz/features/dashboard/providers/scoring_service.dart';
import 'package:habitz/features/habits/providers/habits_provider.dart';

class DashboardSnapshot {
  const DashboardSnapshot({
    required this.completion,
    required this.streak,
    required this.score,
    required this.adaptiveMessage,
    required this.activePlanId,
  });

  final double completion;
  final int streak;
  final ScoreBreakdown score;
  final String adaptiveMessage;
  final String? activePlanId;
}

final scoringServiceProvider = Provider((ref) => ScoringService());

final dashboardProvider = FutureProvider<DashboardSnapshot>((ref) async {
  ref.watch(habitsProvider);
  final habitsRepository = ref.watch(habitsRepositoryProvider);
  final plansRepository = ref.watch(plansRepositoryProvider);
  final completion = await habitsRepository.completionForDate(DateTime.now());
  final workoutCompletion = await plansRepository.weeklyAdherence();
  final streak = await plansRepository.workoutStreakDays();
  final score = ref
      .watch(scoringServiceProvider)
      .calculate(habitCompletion: completion, workoutCompletion: workoutCompletion, streakDays: streak);
  final message = completion > 0.8
      ? 'Momentum unlocked. Keep this pace.'
      : completion > 0.5
          ? 'Solid day. A little more to hit peak mode.'
          : 'Start with one win now. Consistency compounds.';

  return DashboardSnapshot(
    completion: completion,
    streak: streak,
    score: score,
    adaptiveMessage: message,
    activePlanId: await plansRepository.getActivePlanId(),
  );
});
