import 'package:drift/drift.dart';
import 'package:habitz/core/database/app_database.dart';
import 'package:habitz/features/habits/domain/habit.dart';

class HabitsRepository {
  HabitsRepository(this._db);

  final AppDatabase _db;

  Stream<List<HabitModel>> watchHabits() {
    return _db.select(_db.habitEntries).watch().map(
          (rows) => rows
              .map(
                (row) => HabitModel(
                  id: row.id,
                  title: row.title,
                  type: HabitType.values.firstWhere(
                    (type) => type.name == row.type,
                    orElse: () => HabitType.binary,
                  ),
                  targetValue: row.targetValue,
                  unit: row.unit,
                  scheduleDays: row.scheduleDays
                      .split(',')
                      .where((e) => e.isNotEmpty)
                      .map(int.parse)
                      .toList(),
                  reminders: row.reminders
                      .split(',')
                      .where((e) => e.isNotEmpty)
                      .toList(),
                  createdAt: row.createdAt,
                  category: row.category,
                ),
              )
              .toList(),
        );
  }

  Future<void> upsertHabit(HabitModel habit) async {
    await _db
        .into(_db.habitEntries)
        .insertOnConflictUpdate(HabitEntriesCompanion.insert(
          id: habit.id,
          title: habit.title,
          type: habit.type.name,
          targetValue: Value(habit.targetValue),
          unit: Value(habit.unit),
          scheduleDays: habit.scheduleDays.join(','),
          reminders: habit.reminders.join(','),
          createdAt: habit.createdAt,
          category: Value(habit.category),
        ));
  }

  Future<int> habitCount() async {
    final countExpression = _db.habitEntries.id.count();
    final query = _db.selectOnly(_db.habitEntries)..addColumns([countExpression]);
    final row = await query.getSingle();
    return row.read(countExpression) ?? 0;
  }

  Future<void> deleteHabit(String habitId) async {
    await (_db.delete(_db.habitEntries)..where((tbl) => tbl.id.equals(habitId)))
        .go();
  }

  Stream<List<HabitLogModel>> watchLogsForHabit(String habitId) {
    final query = _db.select(_db.habitLogEntries)
      ..where((tbl) => tbl.habitId.equals(habitId))
      ..orderBy([(tbl) => OrderingTerm.desc(tbl.date)]);
    return query.watch().map(
          (rows) => rows
              .map(
                (row) => HabitLogModel(
                  id: row.id,
                  habitId: row.habitId,
                  date: row.date,
                  value: row.value,
                  completed: row.completed,
                  note: row.note,
                ),
              )
              .toList(),
        );
  }

  Future<void> logHabit(HabitLogModel log) async {
    await _db.into(_db.habitLogEntries).insertOnConflictUpdate(
          HabitLogEntriesCompanion.insert(
            id: log.id,
            habitId: log.habitId,
            date: log.date,
            value: Value(log.value),
            completed: Value(log.completed),
            note: Value(log.note),
          ),
        );
  }

  Future<double> completionForDate(DateTime date) async {
    final habits = await _db.select(_db.habitEntries).get();
    if (habits.isEmpty) return 0;
    final start = DateTime(date.year, date.month, date.day);
    final end = start.add(const Duration(days: 1));
    final logs = await (_db.select(_db.habitLogEntries)
          ..where((l) => l.date.isBetweenValues(start, end)))
        .get();
    final completed = logs.where((e) => e.completed).length;
    return completed / habits.length;
  }
}
