import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:habitz/core/database/database_provider.dart';
import 'package:habitz/features/plans/providers/plans_provider.dart';
import 'package:habitz/shared/widgets/neo_card.dart';
import 'package:habitz/theme/app_theme.dart';

class PlanDetailScreen extends ConsumerWidget {
  const PlanDetailScreen({super.key, required this.planId});

  final String planId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final days = ref.watch(planDaysProvider(planId));

    return Scaffold(
      appBar: AppBar(title: const Text('Plan Detail')),
      body: FutureBuilder(
        future: ref.read(plansRepositoryProvider).getPlan(planId),
        builder: (context, snapshot) {
          final plan = snapshot.data;
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (plan == null) {
            return const Center(child: Text('Plan not found'));
          }
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              NeoCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(plan.name, style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(height: 8),
                    Text(plan.description),
                    const SizedBox(height: 8),
                    Text('Expected result: stronger adherence in ${plan.durationWeeks} weeks.'),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              NeoCard(
                child: days.when(
                  data: (items) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Weekly Schedule'),
                      const SizedBox(height: 8),
                      for (final day in items)
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text('Day ${day.dayIndex} • ${day.title}'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () => context.push('/workout/${day.planId}/${day.id}'),
                        )
                    ],
                  ),
                  loading: () => const CircularProgressIndicator(),
                  error: (e, _) => Text(e.toString()),
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.all(20),
        child: FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: AppTheme.accent,
            foregroundColor: Colors.black,
            minimumSize: const Size.fromHeight(52),
          ),
          onPressed: () async {
            await ref.read(plansControllerProvider).startPlan(planId);
            if (context.mounted) context.go('/home');
          },
          child: const Text('Start Plan'),
        ),
      ),
    );
  }
}
