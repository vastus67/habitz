import 'package:flutter/material.dart';
import 'package:habitz/features/plans/domain/workout_models.dart';
import 'package:habitz/shared/widgets/neo_card.dart';
import 'package:habitz/theme/app_theme.dart';

class PlanTile extends StatelessWidget {
  const PlanTile({
    super.key,
    required this.plan,
    required this.onTap,
  });

  final WorkoutPlanModel plan;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: NeoCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(plan.name, style: Theme.of(context).textTheme.titleLarge),
                const Icon(Icons.chevron_right, color: AppTheme.textSecondary),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '${plan.goal.name.toUpperCase()} • ${plan.level.name} • ${plan.equipment.name}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                for (final tag in plan.tags.take(3))
                  Chip(
                    label: Text(tag),
                    backgroundColor: AppTheme.cardSoft,
                    side: BorderSide.none,
                    labelStyle:
                        const TextStyle(color: AppTheme.textPrimary, fontSize: 12),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
