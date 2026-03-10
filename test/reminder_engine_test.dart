import 'package:flutter_test/flutter_test.dart';
import 'package:habitz/features/habits/domain/habit.dart';
import 'package:habitz/features/reminders/services/reminder_engine.dart';

void main() {
  group('ReminderEngine', () {
    test('creates schedule for matching weekday reminders', () {
      final engine = ReminderEngine();
      final monday = DateTime(2026, 3, 2);
      final habits = [
        HabitModel(
          id: 'h1',
          title: 'Hydration',
          type: HabitType.count,
          targetValue: 8,
          unit: 'glasses',
          scheduleDays: const [1],
          reminders: const ['08:00', '14:00'],
          createdAt: DateTime(2026, 1, 1),
        )
      ];

      final events = engine.buildDailySchedule(habits, monday);
      expect(events.length, 2);
      expect(events.first.habitId, 'h1');
    });

    test('creates escalation events when incomplete', () {
      final engine = ReminderEngine();
      final habit = HabitModel(
        id: 'h2',
        title: 'Run',
        type: HabitType.duration,
        targetValue: 30,
        unit: 'min',
        scheduleDays: const [1, 2, 3, 4, 5],
        reminders: const ['18:00'],
        createdAt: DateTime(2026, 1, 1),
      );

      final escalations = engine.buildEscalations(
        habit: habit,
        checkTime: DateTime(2026, 3, 2, 20, 0),
        completed: false,
      );
      expect(escalations.length, 2);
      expect(escalations.last.escalationLevel, 2);
    });
  });
}
