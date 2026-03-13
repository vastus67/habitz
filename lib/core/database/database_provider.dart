import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitz/core/database/app_database.dart';
import 'package:habitz/features/habits/data/habits_repository.dart';
import 'package:habitz/features/plans/data/plans_repository.dart';
import 'package:habitz/features/profile/providers/profile_provider.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final habitsRepositoryProvider = Provider<HabitsRepository>((ref) {
  return HabitsRepository(ref.watch(appDatabaseProvider));
});

final plansRepositoryProvider = Provider<PlansRepository>((ref) {
  return PlansRepository(ref.watch(appDatabaseProvider));
});

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepository(ref.watch(appDatabaseProvider));
});
