import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitz/core/database/app_database.dart';
import 'package:habitz/core/database/database_provider.dart';
import 'package:habitz/features/profile/domain/user_profile.dart';

class ProfileRepository {
  ProfileRepository(this._db);

  final AppDatabase _db;

  Future<UserProfile?> fetch() async {
    final row = await (_db.select(_db.userProfileEntries)).getSingleOrNull();
    if (row == null) return null;
    return UserProfile(
      id: row.id,
      name: row.name,
      sexVariant: SexVariant.values.firstWhere(
        (e) => e.name == row.sexVariant,
        orElse: () => SexVariant.unisex,
      ),
      primaryGoal: UserGoal.values.firstWhere(
        (e) => e.name == row.primaryGoal,
        orElse: () => UserGoal.discipline,
      ),
      equipment: EquipmentType.values.firstWhere(
        (e) => e.name == row.equipment,
        orElse: () => EquipmentType.home,
      ),
      wakeTime: row.wakeTime,
      onboardingCompleted: row.onboardingCompleted,
      proEnabled: row.proEnabled,
    );
  }

  Future<void> save(UserProfile profile, {String? activePlanId}) async {
    await _db.into(_db.userProfileEntries).insertOnConflictUpdate(
          UserProfileEntriesCompanion.insert(
            id: profile.id,
            name: Value(profile.name),
            sexVariant: Value(profile.sexVariant.name),
            primaryGoal: Value(profile.primaryGoal.name),
            equipment: Value(profile.equipment.name),
            wakeTime: Value(profile.wakeTime),
            onboardingCompleted: Value(profile.onboardingCompleted),
            proEnabled: Value(profile.proEnabled),
            activePlanId: Value(activePlanId),
          ),
        );
  }

  Future<void> setOnboardingCompleted(bool completed) async {
    final profile = await fetch();
    if (profile == null) return;
    await (_db.update(_db.userProfileEntries)..where((t) => t.id.equals(profile.id))).write(
      UserProfileEntriesCompanion(onboardingCompleted: Value(completed)),
    );
  }
}

final profileProvider = FutureProvider<UserProfile?>((ref) {
  return ref.watch(profileRepositoryProvider).fetch();
});

final hasCompletedOnboardingProvider = StateProvider<bool>((ref) => false);

final profileControllerProvider =
    StateNotifierProvider<ProfileController, AsyncValue<UserProfile?>>((ref) {
  return ProfileController(
    ref.watch(profileRepositoryProvider),
    ref,
  );
});

class ProfileController extends StateNotifier<AsyncValue<UserProfile?>> {
  ProfileController(this._repository, this._ref) : super(const AsyncValue.loading()) {
    load();
  }

  final ProfileRepository _repository;
  final Ref _ref;

  Future<void> load() async {
    final profile = await _repository.fetch();
    state = AsyncValue.data(profile);
    _ref.read(hasCompletedOnboardingProvider.notifier).state =
        profile?.onboardingCompleted ?? false;
  }

  Future<void> save(UserProfile profile, {String? activePlanId}) async {
    await _repository.save(profile, activePlanId: activePlanId);
    await load();
  }
}
