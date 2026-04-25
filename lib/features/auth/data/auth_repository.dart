import '../../../core/storage/token_storage.dart';
import 'auth_api.dart';

class AuthRepository {
  AuthRepository({
    required AuthApi authApi,
    required TokenStorage tokenStorage,
  })  : _authApi = authApi,
        _tokenStorage = tokenStorage;

  final AuthApi _authApi;
  final TokenStorage _tokenStorage;

  Future<bool> hasSavedSession() async {
    final accessToken = await _tokenStorage.getAccessToken();
    final refreshToken = await _tokenStorage.getRefreshToken();

    return accessToken != null &&
        accessToken.isNotEmpty &&
        refreshToken != null &&
        refreshToken.isNotEmpty;
  }

  Future<void> login({
    required String username,
    required String password,
  }) async {
    final session = await _authApi.login(
      username: username,
      password: password,
    );

    await _tokenStorage.saveTokens(
      accessToken: session.accessToken,
      refreshToken: session.refreshToken,
    );
  }

  Future<void> register({
    required String username,
    required String password,
  }) async {
    final session = await _authApi.register(
      username: username,
      password: password,
    );

    await _tokenStorage.saveTokens(
      accessToken: session.accessToken,
      refreshToken: session.refreshToken,
    );
  }

  Future<void> logout() async {
    final refreshToken = await _tokenStorage.getRefreshToken();

    if (refreshToken != null && refreshToken.isNotEmpty) {
      try {
        await _authApi.logout(refreshToken);
      } catch (_) {
        // Даже если backend недоступен, локальную сессию всё равно очищаем.
      }
    }

    await _tokenStorage.clear();
  }

  Future<void> clearLocalSession() async {
    await _tokenStorage.clear();
  }
}
