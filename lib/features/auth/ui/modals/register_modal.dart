import 'package:flutter/material.dart';

import 'package:kliensy/features/auth/state/auth_controller.dart';
import 'package:kliensy/shared/ui/app_button.dart';
import 'package:kliensy/shared/ui/app_text_field.dart';

import '_auth_modal_card.dart';

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
      builder: (context, _) => AuthModalCard(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(context),
              const SizedBox(height: 18),
              _buildFields(),
              _buildError(context),
              const SizedBox(height: 16),
              _buildSubmitButton(),
              const SizedBox(height: 8),
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
          'Создайте аккаунт',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontSize: 28,
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
      ],
    );
  }

  Widget _buildFields() {
    return Column(
      children: [
        AppTextField(
          controller: businessNameController,
          label: 'Название бизнеса',
          hintText: 'Введите название бизнеса',
          validator: (v) =>
              (v == null || v.trim().isEmpty) ? 'Введите название бизнеса' : null,
        ),
        const SizedBox(height: 10),
        AppTextField(
          controller: fullNameController,
          label: 'Ф.И.О.',
          hintText: 'Введите Ваше Ф.И.О.',
          validator: (v) =>
              (v == null || v.trim().isEmpty) ? 'Введите Ф.И.О.' : null,
        ),
        const SizedBox(height: 10),
        AppTextField(
          controller: usernameController,
          label: 'Логин',
          hintText: 'Введите логин',
          validator: (v) =>
              (v == null || v.trim().isEmpty) ? 'Введите логин' : null,
        ),
        const SizedBox(height: 10),
        AppTextField(
          controller: passwordController,
          label: 'Пароль',
          hintText: 'Пароль',
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
      padding: const EdgeInsets.only(top: 12),
      child: Text(
        authController.errorMessage!,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 12,
          color: Theme.of(context).colorScheme.error,
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return AppButton(
      text: 'Создать аккаунт',
      isLoading: authController.isSubmitting,
      onPressed: onSubmit,
      height: 40,
    );
  }

  Widget _buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Уже есть аккаунт? ',
          style: TextStyle(fontSize: 16, color: Colors.black87),
        ),
        AuthLink(
          text: 'Войти',
          onTap: onGoToLogin,
          disabled: authController.isSubmitting,
        ),
      ],
    );
  }
}
