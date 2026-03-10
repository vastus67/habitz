abstract class SyncService {
  Future<void> pushLocalChanges();
  Future<void> pullRemoteChanges();
  Future<void> resolveConflicts();
}

class SupabaseSyncService implements SyncService {
  @override
  Future<void> pullRemoteChanges() async {}

  @override
  Future<void> pushLocalChanges() async {}

  @override
  Future<void> resolveConflicts() async {}
}
