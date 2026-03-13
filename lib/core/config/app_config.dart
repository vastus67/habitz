class AppConfig {
  const AppConfig._();

  static const String apiBaseUrl = String.fromEnvironment(
    'HABITZ_API_BASE_URL',
    defaultValue: 'https://daily-habits-1048.preview.emergentagent.com',
  );

  static const String oauthScheme = String.fromEnvironment(
    'HABITZ_OAUTH_SCHEME',
    defaultValue: 'habitz',
  );

  static const String oauthHost = String.fromEnvironment(
    'HABITZ_OAUTH_HOST',
    defaultValue: 'auth-callback',
  );

  static Uri get apiUri => Uri.parse(apiBaseUrl);

  static Uri get oauthRedirectUri => Uri(
        scheme: oauthScheme,
        host: oauthHost,
      );

  static Uri get googleAuthUri {
    // REMINDER: DO NOT HARDCODE THE URL, OR ADD ANY FALLBACKS OR REDIRECT URLS, THIS BREAKS THE AUTH
    return Uri.parse('https://auth.emergentagent.com/').replace(
      queryParameters: {'redirect': oauthRedirectUri.toString()},
    );
  }
}
