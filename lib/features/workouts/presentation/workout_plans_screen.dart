import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:habitz/features/mobile_sync/mobile_backend_service.dart';
import 'package:habitz/features/profile/providers/profile_provider.dart';
import 'package:habitz/shared/widgets/plan_tile.dart';

class WorkoutPlansScreen extends ConsumerWidget {
  const WorkoutPlansScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileControllerProvider).valueOrNull;
    final backend = ref.watch(mobileBackendServiceProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Workout Plans')),
      body: FutureBuilder<List<RemotePlanSummary>>(
        future: backend.fetchPlans(),
        builder: (context, snapshot) {
          final plans = snapshot.data ?? const <RemotePlanSummary>[];
          if (snapshot.connectionState == ConnectionState.waiting && plans.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (plans.isEmpty) {
            return const Center(child: Text('No plans match your settings yet.'));
          }
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
            itemCount: plans.length + 1,
            separatorBuilder: (_, __) => const SizedBox(height: 14),
            itemBuilder: (context, index) {
              if (index == 0) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Built around your onboarding profile',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Showing ${profile?.sexVariant.name ?? 'unisex'} plans first, with compatible fallbacks so your recommendations stay useful.',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                );
              }
              final plan = plans[index - 1];
              return PlanTile(
                plan: plan.toLocalModel(),
                onTap: () => context.push('/workout-plan/${plan.id}'),
              );
            },
          );
        },
      ),
    );
  }
}
