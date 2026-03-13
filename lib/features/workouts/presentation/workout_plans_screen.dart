import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:habitz/core/database/database_provider.dart';
import 'package:habitz/features/plans/domain/workout_models.dart';
import 'package:habitz/features/profile/domain/user_profile.dart';
import 'package:habitz/features/profile/providers/profile_provider.dart';
import 'package:habitz/shared/widgets/plan_tile.dart';

class WorkoutPlansScreen extends ConsumerWidget {
  const WorkoutPlansScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileControllerProvider).valueOrNull;
    final repository = ref.watch(plansRepositoryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Workout Plans')),
      body: StreamBuilder<List<WorkoutPlanModel>>(
        stream: repository.watchPlans(
          sexVariant: profile?.sexVariant,
          level: _mapLevel(profile),
          equipment: profile?.equipment,
          goal: _mapGoal(profile),
        ),
        builder: (context, snapshot) {
          final plans = snapshot.data ?? const <WorkoutPlanModel>[];
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
                plan: plan,
                onTap: () => context.push('/workout-plan/${plan.id}'),
              );
            },
          );
        },
      ),
    );
  }

  PlanLevel? _mapLevel(UserProfile? profile) {
    return null;
  }

  PlanGoal? _mapGoal(UserProfile? profile) {
    if (profile == null) return null;
    switch (profile.primaryGoal) {
      case UserGoal.strength:
        return PlanGoal.strength;
      case UserGoal.fatLoss:
        return PlanGoal.fatloss;
      case UserGoal.mobility:
      case UserGoal.sleepReset:
        return PlanGoal.mobility;
      case UserGoal.discipline:
        return null;
    }
  }
}
