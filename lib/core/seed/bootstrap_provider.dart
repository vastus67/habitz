import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitz/core/database/database_provider.dart';
import 'package:habitz/core/seed/seed_service.dart';

final seedServiceProvider = Provider<SeedService>((ref) {
  return SeedService(ref.watch(appDatabaseProvider));
});

final appBootstrapProvider = FutureProvider<void>((ref) async {
  await ref.watch(seedServiceProvider).seedIfNeeded();
});
