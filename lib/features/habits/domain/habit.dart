enum HabitType { binary, count, duration, target, timedReminder }

class HabitModel {
  const HabitModel({
    required this.id,
    required this.title,
    required this.type,
    required this.targetValue,
    required this.unit,
    required this.scheduleDays,
    required this.reminders,
    required this.createdAt,
    this.category,
  });

  final String id;
  final String title;
  final HabitType type;
  final double targetValue;
  final String unit;
  final List<int> scheduleDays;
  final List<String> reminders;
  final DateTime createdAt;
  final String? category;
}

class HabitLogModel {
  const HabitLogModel({
    required this.id,
    required this.habitId,
    required this.date,
    required this.value,
    required this.completed,
    this.note,
  });

  final String id;
  final String habitId;
  final DateTime date;
  final double value;
  final bool completed;
  final String? note;
}
