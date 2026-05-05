import 'package:flutter/material.dart';
import 'package:flutter_smart_wallet_balanced/core/router/app_routes.dart';
import 'package:flutter_smart_wallet_balanced/features/auth/state/auth_controller.dart';
import 'package:flutter_smart_wallet_balanced/features/auth/ui/register_modal.dart';
import 'package:go_router/go_router.dart';

import 'auth_layout.dart';
import 'login_modal.dart';
enum AuthMode { login, register }

class AuthPage extends StatefulWidget {
  const AuthPage({
    super.key,
    required this.authController,
    this.initialMode = AuthMode.login,
  });

  final AuthController authController;
  final AuthMode initialMode;

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool get _isLogin => widget.initialMode == AuthMode.login;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final username = _usernameController.text.trim();
    final password = _passwordController.text;

    if (_isLogin) {
      await widget.authController.login(
        username: username,
        password: password,
      );
    } else {
      await widget.authController.register(
        username: username,
        password: password,
      );
    }
  }

  void _goToRegister() {
    context.go(AppRoutes.register);
  }

  void _goToLogin() {
    context.go(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      modal: _isLogin
          ? LoginModal(
        formKey: _formKey,
        usernameController: _usernameController,
        passwordController: _passwordController,
        authController: widget.authController,
        onSubmit: _submit,
        onGoToRegister: _goToRegister,
      )
          : RegisterModal(
        formKey: _formKey,
        usernameController: _usernameController,
        passwordController: _passwordController,
        authController: widget.authController,
        onSubmit: _submit,
        onGoToLogin: _goToLogin,
      ),
    );
  }
}