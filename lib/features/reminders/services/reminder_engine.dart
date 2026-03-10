import 'package:habitz/features/habits/domain/habit.dart';

class ReminderEvent {
  ReminderEvent({
    required this.habitId,
    required this.title,
    required this.fireAt,
    this.escalationLevel = 0,
  });

  final String habitId;
  final String title;
  final DateTime fireAt;
  final int escalationLevel;
}

class ReminderEngine {
  List<ReminderEvent> buildDailySchedule(List<HabitModel> habits, DateTime day) {
    final events = <ReminderEvent>[];
    final weekday = day.weekday;
    for (final habit in habits) {
      if (!habit.scheduleDays.contains(weekday)) continue;
      for (final reminder in habit.reminders) {
        final split = reminder.split(':');
        if (split.length != 2) continue;
        final eventTime = DateTime(
          day.year,
          day.month,
          day.day,
          int.tryParse(split[0]) ?? 8,
          int.tryParse(split[1]) ?? 0,
        );
        events.add(ReminderEvent(
          habitId: habit.id,
          title: 'Time for ${habit.title}',
          fireAt: eventTime,
        ));
      }
    }
    return events;
  }

  List<ReminderEvent> buildEscalations({
    required HabitModel habit,
    required DateTime checkTime,
    required bool completed,
  }) {
    if (completed) return const [];
    return [
      ReminderEvent(
        habitId: habit.id,
        title: '${habit.title} is still pending',
        fireAt: checkTime,
        escalationLevel: 1,
      ),
      ReminderEvent(
        habitId: habit.id,
        title: 'Final nudge: complete ${habit.title} today',
        fireAt: checkTime.add(const Duration(minutes: 45)),
        escalationLevel: 2,
      ),
    ];
  }
}
