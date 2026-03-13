import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:habitz/features/plans/domain/workout_models.dart';
import 'package:habitz/features/plans/providers/plans_provider.dart';
import 'package:habitz/features/profile/domain/user_profile.dart';
import 'package:habitz/shared/widgets/plan_tile.dart';

class PlansScreen extends ConsumerWidget {
  const PlansScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plans = ref.watch(plansProvider);
    final filter = ref.watch(planFilterProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Plan Library')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _chip<SexVariant>(
                value: filter.sexVariant,
                values: SexVariant.values,
                label: (v) => v.name,
                onSelected: (v) =>
                    ref.read(planFilterProvider.notifier).state = filter.copyWith(sexVariant: v),
              ),
              _chip<PlanGoal>(
                value: filter.goal,
                values: PlanGoal.values,
                label: (v) => v.name,
                onSelected: (v) =>
                    ref.read(planFilterProvider.notifier).state = filter.copyWith(goal: v),
              ),
              _chip<PlanLevel>(
                value: filter.level,
                values: PlanLevel.values,
                label: (v) => v.name,
                onSelected: (v) =>
                    ref.read(planFilterProvider.notifier).state = filter.copyWith(level: v),
              ),
              _chip<EquipmentType>(
                value: filter.equipment,
                values: EquipmentType.values,
                label: (v) => v.name,
                onSelected: (v) =>
                    ref.read(planFilterProvider.notifier).state = filter.copyWith(equipment: v),
              ),
              _intChip(
                value: filter.daysPerWeek,
                values: const [3, 4, 5],
                label: (v) => '${v}d/week',
                onSelected: (v) =>
                    ref.read(planFilterProvider.notifier).state = filter.copyWith(daysPerWeek: v),
              ),
              _intChip(
                value: filter.durationWeeks,
                values: const [6, 8, 10],
                label: (v) => '${v} weeks',
                onSelected: (v) =>
                    ref.read(planFilterProvider.notifier).state = filter.copyWith(durationWeeks: v),
              ),
            ],
          ),
          const SizedBox(height: 16),
          plans.when(
            data: (items) => Column(
              children: [
                for (final plan in items) ...[
                  PlanTile(
                    plan: plan,
                    onTap: () => context.push('/plan/${plan.id}'),
                  ),
                  const SizedBox(height: 12),
                ]
              ],
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Text(e.toString()),
          ),
        ],
      ),
    );
  }

  Widget _chip<T>({
    required T? value,
    required List<T> values,
    required String Function(T) label,
    required ValueChanged<T?> onSelected,
  }) {
    return DropdownButton<T?>(
      value: value,
      hint: Text('Any ${T.toString().replaceAll('Enum', '')}'),
      items: [
        DropdownMenuItem<T?>(value: null, child: const Text('All')),
        ...values.map((v) => DropdownMenuItem<T?>(value: v, child: Text(label(v)))),
      ],
      onChanged: onSelected,
    );
  }

  Widget _intChip({
    required int? value,
    required List<int> values,
    required String Function(int) label,
    required ValueChanged<int?> onSelected,
  }) {
    return DropdownButton<int?>(
      value: value,
      hint: const Text('Any'),
      items: [
        const DropdownMenuItem<int?>(value: null, child: Text('All')),
        ...values.map((v) => DropdownMenuItem<int?>(value: v, child: Text(label(v)))),
      ],
      onChanged: onSelected,
    );
  }
}
