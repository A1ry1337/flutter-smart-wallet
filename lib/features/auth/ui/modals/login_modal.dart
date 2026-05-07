import 'package:flutter/material.dart';

import 'package:kliensy/features/auth/state/auth_controller.dart';
import 'package:kliensy/shared/ui/app_button.dart';
import 'package:kliensy/shared/ui/app_text_field.dart';

import '_auth_modal_card.dart';

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
      builder: (context, _) => AuthModalCard(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(context),
              const SizedBox(height: 28),
              _buildFields(),
              _buildError(context),
              const SizedBox(height: 24),
              _buildSubmitButton(),
              const SizedBox(height: 12),
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        Text(
          'Войдите в свой аккаунт',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontSize: 28,
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
      ],
    );
  }

  Widget _buildFields() {
    return Column(
      children: [
        AppTextField(
          controller: usernameController,
          label: 'Логин',
          hintText: 'Введите логин',
          validator: (v) =>
              (v == null || v.trim().isEmpty) ? 'Введите логин' : null,
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: passwordController,
          label: 'Пароль',
          hintText: 'Введите пароль',
          obscureText: true,
          validator: (v) =>
              (v == null || v.length < 4) ? 'Пароль должен быть минимум 4 символа' : null,
        ),
      ],
    );
  }

  Widget _buildError(BuildContext context) {
    if (authController.errorMessage == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Text(
        authController.errorMessage!,
        textAlign: TextAlign.center,
        style: TextStyle(color: Theme.of(context).colorScheme.error),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return AppButton(
      text: 'Войти',
      isLoading: authController.isSubmitting,
      onPressed: onSubmit,
    );
  }

  Widget _buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Нет аккаунта? ',
          style: TextStyle(fontSize: 16, color: Colors.black87),
        ),
        AuthLink(
          text: 'Зарегистрироваться',
          onTap: onGoToRegister,
          disabled: authController.isSubmitting,
        ),
      ],
    );
  }
}
