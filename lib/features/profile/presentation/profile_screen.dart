import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitz/features/profile/domain/user_profile.dart';
import 'package:habitz/features/profile/providers/profile_provider.dart';
import 'package:habitz/shared/widgets/neo_card.dart';
import 'package:habitz/theme/app_theme.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileControllerProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: profile.when(
        data: (user) {
          if (user == null) {
            return const Center(child: Text('No profile found'));
          }
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              NeoCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user.name, style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(height: 8),
                    Text('Goal: ${user.primaryGoal.name}'),
                    Row(
                      children: [
                        const Text('Sex variant: '),
                        DropdownButton<SexVariant>(
                          value: user.sexVariant,
                          items: SexVariant.values
                              .map((v) => DropdownMenuItem(value: v, child: Text(v.name)))
                              .toList(),
                          onChanged: (value) async {
                            if (value == null) return;
                            await ref.read(profileControllerProvider.notifier).save(
                                  user.copyWith(sexVariant: value),
                                );
                          },
                        ),
                      ],
                    ),
                    Text('Equipment: ${user.equipment.name}'),
                    Text('Wake time: ${user.wakeTime}'),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              NeoCard(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(user.proEnabled ? 'Pro Tier Active' : 'Free Tier (5 habits, 1 plan)'),
                    FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: AppTheme.accent,
                        foregroundColor: Colors.black,
                      ),
                      onPressed: () {},
                      child: const Text('Upgrade'),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
      ),
    );
  }
}
