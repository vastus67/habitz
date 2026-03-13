import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitz/features/habits/domain/habit.dart';
import 'package:habitz/features/habits/providers/habits_provider.dart';
import 'package:habitz/shared/widgets/habit_tile.dart';
import 'package:habitz/shared/widgets/neo_card.dart';
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
            if (index == 0) {
              return NeoCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Consistency stack',
                      style: TextStyle(
                        color: AppTheme.accent,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.1,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text('Your daily habit board.', style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(height: 10),
                    Text(
                      'Tap a habit to log it complete. These habits came from onboarding and can be expanded anytime.',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(child: _HabitStat(value: '${items.length}', label: 'Active habits')),
                        const SizedBox(width: 10),
                        Expanded(child: _HabitStat(value: 'Daily', label: 'Schedule')),
                      ],
                    ),
                  ],
                ),
              );
            }
            final habit = items[index - 1];
            return HabitTile(
              habit: habit,
              onLog: () => ref.read(habitsControllerProvider).logDone(habit),
              onDelete: () => ref.read(habitsControllerProvider).deleteHabit(habit.id),
            );
          },
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemCount: items.length + 1,
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
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Create a habit', style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(height: 8),
                    const Text('Add a new behavior to your daily board.', style: TextStyle(color: AppTheme.textSecondary)),
                    const SizedBox(height: 16),
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
                    const SizedBox(height: 14),
                    FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: AppTheme.accent,
                      foregroundColor: Colors.black,
                        minimumSize: const Size.fromHeight(54),
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
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _HabitStat extends StatelessWidget {
  const _HabitStat({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.cardSoft,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: AppTheme.textSecondary)),
        ],
      ),
    );
  }
}
