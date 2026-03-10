class ScoreBreakdown {
  const ScoreBreakdown({
    required this.dailyScore,
    required this.weeklyConsistency,
    required this.streakMultiplier,
    required this.momentum,
  });

  final int dailyScore;
  final double weeklyConsistency;
  final double streakMultiplier;
  final double momentum;
}

class ScoringService {
  ScoreBreakdown calculate({
    required double habitCompletion,
    required double workoutCompletion,
    required int streakDays,
  }) {
    final streakMultiplier = (1 + (streakDays / 60)).clamp(1.0, 2.0).toDouble();
    final weeklyConsistency =
        ((habitCompletion + workoutCompletion) / 2).clamp(0.0, 1.0).toDouble();
    final momentum = (weeklyConsistency * streakMultiplier).clamp(0.0, 2.0).toDouble();
    final dailyScore = ((habitCompletion * 70) + (workoutCompletion * 30)).round();
    return ScoreBreakdown(
      dailyScore: dailyScore.clamp(0, 100).toInt(),
      weeklyConsistency: weeklyConsistency,
      streakMultiplier: streakMultiplier,
      momentum: momentum,
    );
  }
}
