import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:habitz/features/plans/providers/plans_provider.dart';
import 'package:habitz/shared/widgets/neo_card.dart';
import 'package:habitz/theme/app_theme.dart';

class WorkoutPlansScreen extends ConsumerWidget {
  const WorkoutPlansScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plansAsync = ref.watch(plansProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Workout Plans')),
      body: plansAsync.when(
        data: (plans) => ListView.separated(
          padding: const EdgeInsets.all(20),
          itemCount: plans.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final plan = plans[index];
            return InkWell(
              borderRadius: BorderRadius.circular(24),
              onTap: () => context.push('/workout-plan/${plan.id}'),
              child: NeoCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            plan.name,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                        const Icon(Icons.chevron_right, color: AppTheme.textSecondary),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text('Goal: ${plan.goal.name.toUpperCase()}'),
                    Text('Difficulty: ${plan.difficulty}'),
                    Text('${plan.durationWeeks} weeks • ${plan.daysPerWeek} days/week'),
                    Text('Equipment: ${plan.equipment.name}'),
                  ],
                ),
              ),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text(error.toString())),
      ),
    );
  }
}
