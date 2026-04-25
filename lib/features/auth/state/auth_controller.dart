import 'package:flutter/foundation.dart';

import '../../../core/errors/app_exception.dart';
import '../data/auth_repository.dart';

enum AuthStatus {
  checking,
  unauthenticated,
  authenticated,
}

class AuthController extends ChangeNotifier {
  AuthController(this._authRepository);

  final AuthRepository _authRepository;

  AuthStatus status = AuthStatus.checking;
  bool isSubmitting = false;
  String? errorMessage;

  bool get isAuthenticated => status == AuthStatus.authenticated;

  Future<void> restoreSession() async {
    status = AuthStatus.checking;
    errorMessage = null;
    notifyListeners();

    try {
      final hasSession = await _authRepository.hasSavedSession();
      status = hasSession ? AuthStatus.authenticated : AuthStatus.unauthenticated;
    } catch (_) {
      status = AuthStatus.unauthenticated;
    }

    notifyListeners();
  }

  Future<void> login({
    required String username,
    required String password,
  }) async {
    await _submit(() {
      return _authRepository.login(username: username, password: password);
    });
  }

  Future<void> register({
    required String username,
    required String password,
  }) async {
    await _submit(() {
      return _authRepository.register(username: username, password: password);
    });
  }

  Future<void> logout() async {
    isSubmitting = true;
    errorMessage = null;
    notifyListeners();

    await _authRepository.logout();

    isSubmitting = false;
    status = AuthStatus.unauthenticated;
    notifyListeners();
  }

  Future<void> forceLogout({String? message}) async {
    await _authRepository.clearLocalSession();
    status = AuthStatus.unauthenticated;
    isSubmitting = false;
    errorMessage = message;
    notifyListeners();
  }

  Future<void> _submit(Future<void> Function() action) async {
    isSubmitting = true;
    errorMessage = null;
    notifyListeners();

    try {
      await action();
      status = AuthStatus.authenticated;
    } on AppException catch (e) {
      errorMessage = e.message;
    } catch (_) {
      errorMessage = 'Не удалось выполнить запрос';
    } finally {
      isSubmitting = false;
      notifyListeners();
    }
  }
}
