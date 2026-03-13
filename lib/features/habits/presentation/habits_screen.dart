import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitz/features/habits/domain/habit.dart';
import 'package:habitz/features/habits/providers/habits_provider.dart';
import 'package:habitz/shared/widgets/habit_tile.dart';
import 'package:habitz/theme/app_theme.dart';

class HabitsScreen extends ConsumerWidget {
  const HabitsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habits = ref.watch(habitsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Habits')),
      body: habits.when(
        data: (items) => ListView.separated(
          padding: const EdgeInsets.all(20),
          itemBuilder: (_, index) {
            final habit = items[index];
            return HabitTile(
              habit: habit,
              onLog: () => ref.read(habitsControllerProvider).logDone(habit),
              onTrackSteps: _isWalkingHabit(habit)
                  ? () => _showStepsTrackerDialog(context, ref, habit)
                  : null,
              onDelete: () => ref.read(habitsControllerProvider).deleteHabit(habit.id),
            );
          },
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemCount: items.length,
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppTheme.accent,
        foregroundColor: Colors.black,
        onPressed: () => _showCreateHabitSheet(context, ref),
        label: const Text('New Habit'),
        icon: const Icon(Icons.add),
      ),
    );
  }



  bool _isWalkingHabit(HabitModel habit) {
    final title = habit.title.toLowerCase();
    final unit = habit.unit.toLowerCase();
    final category = habit.category?.toLowerCase() ?? '';
    return title.contains('walk') || unit.contains('step') || category.contains('walk');
  }

  Future<void> _showStepsTrackerDialog(
    BuildContext context,
    WidgetRef ref,
    HabitModel habit,
  ) async {
    final controller = TextEditingController(text: habit.targetValue.toStringAsFixed(0));
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Log steps for ${habit.title}'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(labelText: 'Steps (${habit.unit})'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              final value = double.tryParse(controller.text.trim());
              if (value == null || value < 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Enter a valid step count.')),
                );
                return;
              }
              await ref.read(habitsControllerProvider).logProgress(habit, value);
              if (context.mounted) {
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _showCreateHabitSheet(BuildContext context, WidgetRef ref) async {
    final titleController = TextEditingController();
    final targetController = TextEditingController(text: '1');
    final unitController = TextEditingController(text: 'times');
    HabitType selectedType = HabitType.binary;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: StatefulBuilder(
            builder: (context, setModalState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(labelText: 'Habit title'),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<HabitType>(
                    value: selectedType,
                    items: HabitType.values
                        .map((e) => DropdownMenuItem(value: e, child: Text(e.name)))
                        .toList(),
                    onChanged: (v) => setModalState(() => selectedType = v ?? HabitType.binary),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: targetController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Target value'),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: unitController,
                    decoration: const InputDecoration(labelText: 'Unit'),
                  ),
                  const SizedBox(height: 12),
                  FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: AppTheme.accent,
                      foregroundColor: Colors.black,
                    ),
                    onPressed: () async {
                      try {
                        await ref.read(habitsControllerProvider).createHabit(
                              title: titleController.text.trim(),
                              type: selectedType,
                              targetValue: double.tryParse(targetController.text) ?? 1,
                              unit: unitController.text.trim(),
                              scheduleDays: const [1, 2, 3, 4, 5, 6, 7],
                              reminders: const ['08:00'],
                            );
                        if (context.mounted) Navigator.pop(context);
                      } catch (e) {
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(e.toString())),
                        );
                      }
                    },
                    child: const Text('Create Habit'),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
