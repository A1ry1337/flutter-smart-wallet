import 'package:flutter/material.dart';

import '../../../shared/ui/app_button.dart';
import '../../../shared/ui/app_text_field.dart';
import '../state/auth_controller.dart';

enum AuthMode { login, register }

class AuthPage extends StatefulWidget {
  const AuthPage({
    super.key,
    required this.authController,
  });

  final AuthController authController;

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  AuthMode _mode = AuthMode.login;

  bool get _isLogin => _mode == AuthMode.login;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final username = _usernameController.text.trim();
    final password = _passwordController.text;

    if (_isLogin) {
      await widget.authController.login(username: username, password: password);
    } else {
      await widget.authController.register(username: username, password: password);
    }
  }

  void _toggleMode() {
    setState(() {
      _mode = _isLogin ? AuthMode.register : AuthMode.login;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: AnimatedBuilder(
              animation: widget.authController,
              builder: (context, _) {
                final controller = widget.authController;

                return Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                    side: BorderSide(color: Theme.of(context).dividerColor),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            _isLogin ? 'Вход' : 'Регистрация',
                            style: Theme.of(context).textTheme.headlineMedium,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Spring Smart Wallet',
                            style: Theme.of(context).textTheme.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          AppTextField(
                            controller: _usernameController,
                            label: 'Username',
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Введите username';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          AppTextField(
                            controller: _passwordController,
                            label: 'Password',
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.length < 4) {
                                return 'Пароль должен быть минимум 4 символа';
                              }
                              return null;
                            },
                          ),
                          if (controller.errorMessage != null) ...[
                            const SizedBox(height: 16),
                            Text(
                              controller.errorMessage!,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.error,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                          const SizedBox(height: 24),
                          AppButton(
                            text: _isLogin ? 'Войти' : 'Создать аккаунт',
                            isLoading: controller.isSubmitting,
                            onPressed: _submit,
                          ),
                          const SizedBox(height: 12),
                          TextButton(
                            onPressed: controller.isSubmitting ? null : _toggleMode,
                            child: Text(
                              _isLogin
                                  ? 'Нет аккаунта? Зарегистрироваться'
                                  : 'Уже есть аккаунт? Войти',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
