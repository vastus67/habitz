import 'package:flutter/material.dart';
import 'package:habitz/features/habits/domain/habit.dart';
import 'package:habitz/shared/widgets/neo_card.dart';
import 'package:habitz/theme/app_theme.dart';

class HabitTile extends StatelessWidget {
  const HabitTile({
    super.key,
    required this.habit,
    required this.currentValue,
    required this.onMarkDone,
    this.onQuickAdd,
    this.onSetProgress,
    this.quickAddLabel,
    this.onDelete,
  });

  final HabitModel habit;
  final double currentValue;
  final VoidCallback onMarkDone;
  final VoidCallback? onQuickAdd;
  final VoidCallback? onSetProgress;
  final String? quickAddLabel;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final progress = habit.targetValue <= 0 ? 0.0 : (currentValue / habit.targetValue).clamp(0.0, 1.0);
    final completed = currentValue >= habit.targetValue;

    return NeoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 40,
                width: 40,
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
                      '${currentValue.toStringAsFixed(0)} / ${habit.targetValue.toStringAsFixed(0)} ${habit.unit}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              if (onSetProgress != null)
                IconButton(
                  tooltip: 'Set progress',
                  onPressed: onSetProgress,
                  icon: const Icon(Icons.edit_outlined, color: AppTheme.accent),
                ),
              IconButton(
                tooltip: 'Mark done',
                onPressed: onMarkDone,
                icon: const Icon(Icons.check_circle_outline, color: AppTheme.accent),
              ),
              if (onDelete != null)
                IconButton(
                  tooltip: 'Delete habit',
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete_outline),
                ),
            ],
          ),
          const SizedBox(height: 10),
          LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            borderRadius: BorderRadius.circular(10),
            backgroundColor: AppTheme.cardSoft,
            valueColor: AlwaysStoppedAnimation<Color>(
              completed ? AppTheme.accent : Colors.lightBlueAccent,
            ),
          ),
          if (onQuickAdd != null) ...[
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: onQuickAdd,
              icon: const Icon(Icons.add),
              label: Text(quickAddLabel ?? 'Add progress'),
            ),
          ],
        ],
      ),
    );
  }
}
