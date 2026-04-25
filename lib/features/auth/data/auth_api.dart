import '../../../core/network/api_client.dart';
import '../models/auth_session.dart';

class AuthApi {
  AuthApi(this._apiClient);

  final ApiClient _apiClient;

  Future<AuthSession> login({
    required String username,
    required String password,
  }) async {
    final response = await _apiClient.post(
      '/api/auth/login',
      auth: false,
      body: {
        'username': username,
        'password': password,
      },
    );

    return AuthSession.fromJson(response as Map<String, dynamic>);
  }

  Future<AuthSession> register({
    required String username,
    required String password,
  }) async {
    final response = await _apiClient.post(
      '/api/auth/register',
      auth: false,
      body: {
        'username': username,
        'password': password,
      },
    );

    return AuthSession.fromJson(response as Map<String, dynamic>);
  }

  Future<void> logout(String refreshToken) async {
    await _apiClient.post(
      '/api/auth/logout',
      auth: false,
      body: {'refreshToken': refreshToken},
    );
  }
}
