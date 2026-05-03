import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import 'app.dart';
import 'core/config/app_config.dart';
import 'core/network/api_client.dart';
import 'core/storage/shared_prefs_token_storage.dart';
import 'features/auth/data/auth_api.dart';
import 'features/auth/data/auth_repository.dart';
import 'features/auth/state/auth_controller.dart';
import 'features/home/data/user_api.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setUrlStrategy(PathUrlStrategy());

  final prefs = await SharedPreferences.getInstance();
  final tokenStorage = SharedPrefsTokenStorage(prefs);

  final apiClient = ApiClient(
    baseUrl: AppConfig.apiBaseUrl,
    tokenStorage: tokenStorage,
  );

  final authApi = AuthApi(apiClient);
  final authRepository = AuthRepository(
    authApi: authApi,
    tokenStorage: tokenStorage,
  );

  final authController = AuthController(authRepository);
  final userApi = UserApi(apiClient);

  await authController.restoreSession();

  runApp(
    SmartWalletApp(
      authController: authController,
      userApi: userApi,
    ),
  );
}
