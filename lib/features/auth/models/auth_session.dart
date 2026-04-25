class AuthSession {
  const AuthSession({
    required this.accessToken,
    required this.refreshToken,
  });

  final String accessToken;
  final String refreshToken;

  factory AuthSession.fromJson(Map<String, dynamic> json) {
    final accessToken = json['accessToken'] as String?;
    final refreshToken = json['refreshToken'] as String?;

    if (accessToken == null || refreshToken == null) {
      throw const FormatException('Backend не вернул accessToken или refreshToken');
    }

    return AuthSession(
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }
}
