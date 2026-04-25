import 'package:flutter/material.dart';

import '../../../core/errors/app_exception.dart';
import '../../../shared/ui/app_button.dart';
import '../../auth/state/auth_controller.dart';
import '../data/user_api.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    required this.authController,
    required this.userApi,
  });

  final AuthController authController;
  final UserApi userApi;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLoadingUser = false;
  Map<String, dynamic>? _userData;
  String? _error;

  Future<void> _loadUser() async {
    setState(() {
      _isLoadingUser = true;
      _error = null;
    });

    try {
      final userData = await widget.userApi.getUserFromJwt();

      if (!mounted) return;
      setState(() {
        _userData = userData;
      });
    } on ApiException catch (e) {
      if (e.statusCode == 401 || e.statusCode == 403) {
        await widget.authController.forceLogout(message: 'Сессия истекла');
        return;
      }

      if (!mounted) return;
      setState(() {
        _error = e.message;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _error = 'Не удалось загрузить данные';
      });
    } finally {
      if (!mounted) return;
      setState(() {
        _isLoadingUser = false;
      });
    }
  }

  Future<void> _logout() async {
    await widget.authController.logout();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Wallet'),
        actions: [
          TextButton(
            onPressed: _logout,
            child: const Text('Выйти'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
                side: BorderSide(color: Theme.of(context).dividerColor),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Ты авторизован',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Нажми кнопку ниже, чтобы проверить защищённый endpoint /test/get_user_from_jwt.',
                    ),
                    const SizedBox(height: 24),
                    AppButton(
                      text: 'Проверить JWT',
                      isLoading: _isLoadingUser,
                      onPressed: _loadUser,
                    ),
                    if (_error != null) ...[
                      const SizedBox(height: 16),
                      Text(
                        _error!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ],
                    if (_userData != null) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(_userData.toString()),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
