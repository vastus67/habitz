import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitz/core/database/database_provider.dart';
import 'package:habitz/core/utils/id_generator.dart';
import 'package:habitz/features/habits/domain/habit.dart';

final habitsProvider = StreamProvider<List<HabitModel>>((ref) {
  return ref.watch(habitsRepositoryProvider).watchHabits();
});

final habitsControllerProvider = Provider<HabitsController>((ref) {
  return HabitsController(ref);
});

class HabitsController {
  HabitsController(this._ref);
  final Ref _ref;

  Future<void> createHabit({
    required String title,
    required HabitType type,
    required double targetValue,
    required String unit,
    required List<int> scheduleDays,
    required List<String> reminders,
    String? category,
  }) async {
    final profile = await _ref.read(profileRepositoryProvider).fetch();
    final count = await _ref.read(habitsRepositoryProvider).habitCount();
    final canCreate = (profile?.proEnabled ?? false) || count < 5;
    if (!canCreate) {
      throw Exception('Free tier allows up to 5 habits. Upgrade to Pro for unlimited habits.');
    }

    final now = DateTime.now();
    final id = IdGenerator.deterministic('habit', [title, now.toIso8601String()]);
    final model = HabitModel(
      id: id,
      title: title,
      type: type,
      targetValue: targetValue,
      unit: unit,
      scheduleDays: scheduleDays,
      reminders: reminders,
      createdAt: now,
      category: category,
    );
    await _ref.read(habitsRepositoryProvider).upsertHabit(model);
  }

  Future<void> deleteHabit(String id) {
    return _ref.read(habitsRepositoryProvider).deleteHabit(id);
  }

  Future<void> logDone(HabitModel habit, {double? value}) async {
    final now = DateTime.now();
    final id = IdGenerator.deterministic(
      'habitLog',
      [habit.id, now.year.toString(), now.month.toString(), now.day.toString()],
    );
    await _ref.read(habitsRepositoryProvider).logHabit(
          HabitLogModel(
            id: id,
            habitId: habit.id,
            date: now,
            value: value ?? habit.targetValue,
            completed: true,
          ),
        );
  }
}
