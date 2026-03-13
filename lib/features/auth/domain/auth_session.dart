class AuthSession {
  const AuthSession({
    required this.userId,
    required this.email,
    required this.name,
    required this.sessionToken,
    this.pictureUrl,
    this.providers = const <String>[],
  });

  final String userId;
  final String email;
  final String name;
  final String sessionToken;
  final String? pictureUrl;
  final List<String> providers;

  factory AuthSession.fromBackend(Map<String, dynamic> payload) {
    final user = Map<String, dynamic>.from(payload['user'] as Map);
    return AuthSession(
      userId: user['user_id'] as String,
      email: user['email'] as String,
      name: (user['name'] as String?) ?? 'Athlete',
      sessionToken: (payload['session_token'] as String?) ?? '',
      pictureUrl: user['picture'] as String?,
      providers: (user['providers'] as List?)?.map((item) => '$item').toList() ?? const <String>[],
    );
  }

  factory AuthSession.fromStorage(Map<String, dynamic> payload) {
    return AuthSession(
      userId: payload['user_id'] as String,
      email: payload['email'] as String,
      name: payload['name'] as String,
      sessionToken: payload['session_token'] as String,
      pictureUrl: payload['picture_url'] as String?,
      providers: (payload['providers'] as List?)?.map((item) => '$item').toList() ?? const <String>[],
    );
  }

  Map<String, dynamic> toStorage() {
    return {
      'user_id': userId,
      'email': email,
      'name': name,
      'session_token': sessionToken,
      'picture_url': pictureUrl,
      'providers': providers,
    };
  }
}
