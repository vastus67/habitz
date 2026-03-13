import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:habitz/core/config/app_config.dart';
import 'package:habitz/features/auth/domain/auth_session.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

final authControllerProvider =
    StateNotifierProvider<AuthController, AsyncValue<AuthSession?>>((ref) {
  return AuthController(ref.watch(authRepositoryProvider))..restoreSession();
});

class AuthRepository {
  AuthRepository({http.Client? client, FlutterSecureStorage? storage})
      : _client = client ?? http.Client(),
        _storage = storage ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(encryptedSharedPreferences: true),
            );

  final http.Client _client;
  final FlutterSecureStorage _storage;
  static const _sessionKey = 'habitz_session';

  Future<AuthSession?> restoreSession() async {
    final raw = await _storage.read(key: _sessionKey);
    if (raw == null || raw.isEmpty) return null;
    final cached = AuthSession.fromStorage(
      Map<String, dynamic>.from(jsonDecode(raw) as Map),
    );
    final verified = await me(cached.sessionToken);
    if (verified == null) {
      await clearSession();
      return null;
    }
    final session = AuthSession(
      userId: verified.userId,
      email: verified.email,
      name: verified.name,
      pictureUrl: verified.pictureUrl,
      providers: verified.providers,
      sessionToken: cached.sessionToken,
    );
    await persistSession(session);
    return session;
  }

  Future<AuthSession> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final payload = await _postJson(
      '/api/auth/register',
      {'name': name, 'email': email, 'password': password},
    );
    final session = AuthSession.fromBackend(payload);
    await persistSession(session);
    return session;
  }

  Future<AuthSession> login({
    required String email,
    required String password,
  }) async {
    final payload = await _postJson(
      '/api/auth/login',
      {'email': email, 'password': password},
    );
    final session = AuthSession.fromBackend(payload);
    await persistSession(session);
    return session;
  }

  Future<AuthSession> exchangeGoogleSession(String sessionId) async {
    final payload = await _postJson(
      '/api/auth/google/session',
      {'session_id': sessionId},
    );
    final session = AuthSession.fromBackend(payload);
    await persistSession(session);
    return session;
  }

  Future<AuthSession?> me(String sessionToken) async {
    final response = await _client.get(
      AppConfig.apiUri.resolve('/api/auth/me'),
      headers: {'Authorization': 'Bearer $sessionToken'},
    );
    if (response.statusCode >= 400) return null;
    final decoded = Map<String, dynamic>.from(jsonDecode(response.body) as Map);
    final user = Map<String, dynamic>.from(decoded['user'] as Map);
    return AuthSession(
      userId: user['user_id'] as String,
      email: user['email'] as String,
      name: (user['name'] as String?) ?? 'Athlete',
      pictureUrl: user['picture'] as String?,
      providers: (user['providers'] as List?)?.map((item) => '$item').toList() ?? const <String>[],
      sessionToken: sessionToken,
    );
  }

  Future<void> logout(String sessionToken) async {
    try {
      await _client.post(
        AppConfig.apiUri.resolve('/api/auth/logout'),
        headers: {'Authorization': 'Bearer $sessionToken'},
      );
    } finally {
      await clearSession();
    }
  }

  Future<void> persistSession(AuthSession session) {
    return _storage.write(
      key: _sessionKey,
      value: jsonEncode(session.toStorage()),
    );
  }

  Future<void> clearSession() => _storage.delete(key: _sessionKey);

  Future<Map<String, dynamic>> _postJson(String path, Map<String, dynamic> body) async {
    final response = await _client.post(
      AppConfig.apiUri.resolve(path),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
    final decoded = jsonDecode(response.body);
    if (response.statusCode >= 400) {
      final detail = decoded is Map<String, dynamic> ? decoded['detail'] : null;
      throw Exception(detail ?? 'Request failed');
    }
    return Map<String, dynamic>.from(decoded as Map);
  }
}

class AuthController extends StateNotifier<AsyncValue<AuthSession?>> {
  AuthController(this._repository) : super(const AsyncValue.loading());

  final AuthRepository _repository;

  Future<void> restoreSession() async {
    try {
      final session = await _repository.restoreSession();
      state = AsyncValue.data(session);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      state = const AsyncValue.data(null);
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => _repository.register(name: name, email: email, password: password),
    );
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => _repository.login(email: email, password: password),
    );
  }

  Future<void> completeGoogleSignIn(String sessionId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => _repository.exchangeGoogleSession(sessionId),
    );
  }

  Future<void> logout() async {
    final token = state.valueOrNull?.sessionToken;
    state = const AsyncValue.loading();
    if (token != null && token.isNotEmpty) {
      await _repository.logout(token);
    } else {
      await _repository.clearSession();
    }
    state = const AsyncValue.data(null);
  }
}