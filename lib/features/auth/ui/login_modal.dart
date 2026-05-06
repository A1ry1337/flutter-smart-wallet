import 'package:flutter/material.dart';
import 'package:kliensy/features/auth/state/auth_controller.dart';
import 'package:kliensy/shared/ui/app_button.dart';
import 'package:kliensy/shared/ui/app_text_field.dart';


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
          elevation: 18,
          shadowColor: Colors.black.withOpacity(0.18),
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(
              color: Color(0xFFE0E0E0),
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Войдите в свой аккаунт',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Управляйте заявками и клиентами\nвашего бизнеса в одном месте',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 28),

                  AppTextField(
                    controller: usernameController,
                    label: 'Логин',
                    hintText: 'Введите логин',
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Введите Логин';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  AppTextField(
                    controller: passwordController,
                    label: 'Пароль',
                    hintText: 'Введите пароль',
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

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Нет аккаунта? ',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: InkWell(
                          onTap: authController.isSubmitting ? null : onGoToRegister,
                          hoverColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          child: Text(
                            'Зарегистрироваться',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: authController.isSubmitting
                                  ? Colors.grey
                                  : const Color(0xFF0A3CC0),
                            ),
                          ),
                        ),
                      ),
                    ],
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