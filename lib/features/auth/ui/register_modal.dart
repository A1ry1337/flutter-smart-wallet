import 'package:flutter/material.dart';
import 'package:kliensy/features/auth/state/auth_controller.dart';
import 'package:kliensy/shared/ui/app_button.dart';
import 'package:kliensy/shared/ui/app_text_field.dart';

class RegisterModal extends StatelessWidget {
  const RegisterModal({
    super.key,
    required this.formKey,
    required this.businessNameController,
    required this.fullNameController,
    required this.usernameController,
    required this.passwordController,
    required this.authController,
    required this.onSubmit,
    required this.onGoToLogin,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController businessNameController;
  final TextEditingController fullNameController;
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final AuthController authController;
  final VoidCallback onSubmit;
  final VoidCallback onGoToLogin;

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
                    'Создайте аккаунт',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),

                  const SizedBox(height: 14),

                  Text(
                    'Начните работать с клиентами\nи заявками уже сегодня',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 18),

                  AppTextField(
                    controller: businessNameController,
                    label: 'Название бизнеса',
                    hintText: 'Введите название бизнеса',
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Введите название бизнеса';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 10),

                  AppTextField(
                    controller: fullNameController,
                    label: 'Ф.И.О.',
                    hintText: 'Введите Ваше Ф.И.О.',
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Введите Ф.И.О.';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 10),

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

                  const SizedBox(height: 10),

                  AppTextField(
                    controller: passwordController,
                    label: 'Пароль',
                    hintText: 'Пароль',
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.length < 4) {
                        return 'Пароль должен быть минимум 4 символа';
                      }
                      return null;
                    },
                  ),

                  if (authController.errorMessage != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      authController.errorMessage!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ],

                  const SizedBox(height: 16),

                  AppButton(
                    text: 'Создать аккаунт',
                    isLoading: authController.isSubmitting,
                    onPressed: onSubmit,
                    height: 40
                  ),

                  const SizedBox(height: 8),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Уже есть аккаунт? ',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: InkWell(
                          onTap: authController.isSubmitting ? null : onGoToLogin,
                          hoverColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          child: Text(
                            'Войти',
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