import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:habitz/core/database/database_provider.dart';
import 'package:habitz/features/auth/providers/auth_provider.dart';
import 'package:habitz/features/profile/domain/user_profile.dart';
import 'package:habitz/features/profile/providers/profile_provider.dart';
import 'package:habitz/shared/widgets/neo_card.dart';
import 'package:habitz/theme/app_theme.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  String _goalLabel(UserGoal goal) {
    switch (goal) {
      case UserGoal.discipline:
        return 'Discipline';
      case UserGoal.fatLoss:
        return 'Fat loss';
      case UserGoal.strength:
        return 'Strength';
      case UserGoal.mobility:
        return 'Mobility';
      case UserGoal.sleepReset:
        return 'Energy & sleep';
    }
  }

  String _sexLabel(SexVariant variant) {
    switch (variant) {
      case SexVariant.male:
        return 'Male';
      case SexVariant.female:
        return 'Female';
      case SexVariant.unisex:
        return 'Unisex';
    }
  }

  String _equipmentLabel(EquipmentType equipment) {
    switch (equipment) {
      case EquipmentType.none:
        return 'No equipment';
      case EquipmentType.home:
        return 'Home setup';
      case EquipmentType.gym:
        return 'Full gym';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileControllerProvider);
    final auth = ref.watch(authControllerProvider).valueOrNull;
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
                    Text(
                      'Goal: ${_goalLabel(user.primaryGoal)}',
                      style: const TextStyle(color: AppTheme.textSecondary),
                    ),
                    const SizedBox(height: 12),
                    if (auth != null)
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppTheme.cardSoft,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(auth.email, style: const TextStyle(fontWeight: FontWeight.w700)),
                            const SizedBox(height: 6),
                            Text(
                              'Connected with ${auth.providers.join(' + ')}',
                              style: const TextStyle(color: AppTheme.textSecondary),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _ProfileSelector<SexVariant>(
                            label: 'Workout style',
                            value: user.sexVariant,
                            items: SexVariant.values,
                            itemLabel: _sexLabel,
                            onChanged: (value) async {
                              if (value == null) return;
                              await ref.read(profileControllerProvider.notifier).save(
                                    user.copyWith(sexVariant: value),
                                  );
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: _ProfileSelector<UserGoal>(
                            label: 'Primary goal',
                            value: user.primaryGoal,
                            items: UserGoal.values,
                            itemLabel: _goalLabel,
                            onChanged: (value) async {
                              if (value == null) return;
                              await ref.read(profileControllerProvider.notifier).save(
                                    user.copyWith(primaryGoal: value),
                                  );
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: _ProfileSelector<EquipmentType>(
                            label: 'Equipment',
                            value: user.equipment,
                            items: EquipmentType.values,
                            itemLabel: _equipmentLabel,
                            onChanged: (value) async {
                              if (value == null) return;
                              await ref.read(profileControllerProvider.notifier).save(
                                    user.copyWith(equipment: value),
                                  );
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    InkWell(
                      borderRadius: BorderRadius.circular(18),
                      onTap: () async {
                        final picked = await showTimePicker(
                          context: context,
                          initialTime: _parseTime(user.wakeTime),
                        );
                        if (picked == null) return;
                        final hh = picked.hour.toString().padLeft(2, '0');
                        final mm = picked.minute.toString().padLeft(2, '0');
                        await ref.read(profileControllerProvider.notifier).save(
                              user.copyWith(wakeTime: '$hh:$mm'),
                            );
                      },
                      child: InputDecorator(
                        decoration: const InputDecoration(labelText: 'Wake time'),
                        child: Text(user.wakeTime),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              NeoCard(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Current profile: ${_sexLabel(user.sexVariant)} • ${_goalLabel(user.primaryGoal)} • ${_equipmentLabel(user.equipment)}',
                        style: const TextStyle(color: AppTheme.textSecondary),
                      ),
                    ),
                    FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: AppTheme.accent,
                        foregroundColor: Colors.black,
                      ),
                      onPressed: () async {
                        await ref.read(appDatabaseProvider).clearUserProgress();
                        await ref.read(profileControllerProvider.notifier).load();
                        await ref.read(authControllerProvider.notifier).logout();
                        if (context.mounted) {
                          context.go('/auth');
                        }
                      },
                      child: const Text('Sign out'),
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

  TimeOfDay _parseTime(String value) {
    final parts = value.split(':');
    final hour = parts.isNotEmpty ? int.tryParse(parts.first) ?? 7 : 7;
    final minute = parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0;
    return TimeOfDay(hour: hour, minute: minute);
  }
}

class _ProfileSelector<T> extends StatelessWidget {
  const _ProfileSelector({
    required this.label,
    required this.value,
    required this.items,
    required this.itemLabel,
    required this.onChanged,
  });

  final String label;
  final T value;
  final List<T> items;
  final String Function(T value) itemLabel;
  final ValueChanged<T?> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: value,
      decoration: InputDecoration(labelText: label),
      items: items
          .map(
            (item) => DropdownMenuItem<T>(
              value: item,
              child: Text(itemLabel(item)),
            ),
          )
          .toList(),
      onChanged: onChanged,
    );
  }
}
