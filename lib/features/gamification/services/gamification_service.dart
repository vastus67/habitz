class GamificationSnapshot {
  const GamificationSnapshot({
    required this.xp,
    required this.level,
    required this.badges,
  });

  final int xp;
  final int level;
  final List<String> badges;
}

class GamificationService {
  GamificationSnapshot calculate({
    required int habitsCompleted,
    required int workoutsCompleted,
    required int streakDays,
  }) {
    final xp = (habitsCompleted * 10) + (workoutsCompleted * 30) + (streakDays * 2);
    final level = (xp / 120).floor() + 1;
    final badges = <String>[];
    if (streakDays >= 7) badges.add('7-Day Streak');
    if (streakDays >= 30) badges.add('30-Day Streak');
    if (streakDays >= 90) badges.add('90-Day Streak');
    if (workoutsCompleted >= 4) badges.add('Plan Week Complete');
    return GamificationSnapshot(xp: xp, level: level, badges: badges);
  }
}
