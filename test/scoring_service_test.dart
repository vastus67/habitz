import 'package:flutter_test/flutter_test.dart';
import 'package:habitz/features/dashboard/providers/scoring_service.dart';

void main() {
  group('ScoringService', () {
    test('calculates bounded daily score and momentum', () {
      final service = ScoringService();
      final result = service.calculate(
        habitCompletion: 0.9,
        workoutCompletion: 0.8,
        streakDays: 14,
      );

      expect(result.dailyScore, inInclusiveRange(0, 100));
      expect(result.weeklyConsistency, closeTo(0.85, 0.0001));
      expect(result.streakMultiplier, greaterThan(1));
      expect(result.momentum, greaterThan(0));
    });
  });
}
