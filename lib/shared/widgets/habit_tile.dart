import 'package:flutter/material.dart';
import 'package:habitz/features/habits/domain/habit.dart';
import 'package:habitz/shared/widgets/neo_card.dart';
import 'package:habitz/theme/app_theme.dart';

class HabitTile extends StatelessWidget {
  const HabitTile({
    super.key,
    required this.habit,
    required this.onLog,
    this.onDelete,
  });

  final HabitModel habit;
  final VoidCallback onLog;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return NeoCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 48,
            width: 48,
            decoration: const BoxDecoration(
              color: AppTheme.accent,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.bolt, color: Colors.black),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(habit.title, style: Theme.of(context).textTheme.titleLarge),
                Text(
                  '${habit.type.name} • Target ${habit.targetValue} ${habit.unit}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          FilledButton.tonal(
            onPressed: onLog,
            style: FilledButton.styleFrom(
              foregroundColor: Colors.black,
              backgroundColor: AppTheme.accent,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: const Icon(Icons.check_rounded),
          ),
          if (onDelete != null)
            IconButton(
              onPressed: onDelete,
              icon: const Icon(Icons.delete_outline),
            )
        ],
      ),
    );
  }
}
