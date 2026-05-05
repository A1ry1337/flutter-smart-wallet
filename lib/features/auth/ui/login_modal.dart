import 'package:flutter/material.dart';
import 'package:flutter_smart_wallet_balanced/features/auth/state/auth_controller.dart';
import 'package:flutter_smart_wallet_balanced/shared/ui/app_button.dart';
import 'package:flutter_smart_wallet_balanced/shared/ui/app_text_field.dart';


class LoginModal extends StatelessWidget {
  const LoginModal({
    super.key,
    required this.formKey,
    required this.usernameController,
    required this.passwordController,
    required this.authController,
    required this.onSubmit,
    required this.onGoToRegister,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final AuthController authController;
  final VoidCallback onSubmit;
  final VoidCallback onGoToRegister;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: authController,
      builder: (context, _) {
        return Card(
          elevation: 22,
          shadowColor: Colors.black.withOpacity(0.12),
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Вход',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Добро пожаловать обратно',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 28),

                  AppTextField(
                    controller: usernameController,
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
                    controller: passwordController,
                    label: 'Password',
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.length < 4) {
                        return 'Пароль должен быть минимум 4 символа';
                      }
                      return null;
                    },
                  ),

                  if (authController.errorMessage != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      authController.errorMessage!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ],

                  const SizedBox(height: 24),

                  AppButton(
                    text: 'Войти',
                    isLoading: authController.isSubmitting,
                    onPressed: onSubmit,
                  ),

                  const SizedBox(height: 12),

                  TextButton(
                    onPressed:
                    authController.isSubmitting ? null : onGoToRegister,
                    child: const Text('Нет аккаунта? Зарегистрироваться'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}