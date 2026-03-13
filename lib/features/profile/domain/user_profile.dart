enum UserGoal { discipline, fatLoss, strength, mobility, sleepReset }

enum SexVariant { male, female, unisex }

enum EquipmentType { none, home, gym }

class UserProfile {
  const UserProfile({
    required this.id,
    required this.name,
    required this.sexVariant,
    required this.primaryGoal,
    required this.equipment,
    required this.wakeTime,
    required this.onboardingCompleted,
    this.proEnabled = false,
  });

  final String id;
  final String name;
  final SexVariant sexVariant;
  final UserGoal primaryGoal;
  final EquipmentType equipment;
  final String wakeTime;
  final bool onboardingCompleted;
  final bool proEnabled;

  UserProfile copyWith({
    String? name,
    SexVariant? sexVariant,
    UserGoal? primaryGoal,
    EquipmentType? equipment,
    String? wakeTime,
    bool? onboardingCompleted,
    bool? proEnabled,
  }) {
    return UserProfile(
      id: id,
      name: name ?? this.name,
      sexVariant: sexVariant ?? this.sexVariant,
      primaryGoal: primaryGoal ?? this.primaryGoal,
      equipment: equipment ?? this.equipment,
      wakeTime: wakeTime ?? this.wakeTime,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
      proEnabled: proEnabled ?? this.proEnabled,
    );
  }
}
