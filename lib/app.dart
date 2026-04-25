import 'package:flutter/material.dart';

import 'features/auth/state/auth_controller.dart';
import 'features/auth/ui/auth_page.dart';
import 'features/home/data/user_api.dart';
import 'features/home/ui/home_page.dart';

class SmartWalletApp extends StatelessWidget {
  const SmartWalletApp({
    super.key,
    required this.authController,
    required this.userApi,
  });

  final AuthController authController;
  final UserApi userApi;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Wallet',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
        ),
      ),
      home: AnimatedBuilder(
        animation: authController,
        builder: (context, _) {
          return switch (authController.status) {
            AuthStatus.checking => const _SplashPage(),
            AuthStatus.unauthenticated => AuthPage(
                authController: authController,
              ),
            AuthStatus.authenticated => HomePage(
                authController: authController,
                userApi: userApi,
              ),
          };
        },
      ),
    );
  }
}

class _SplashPage extends StatelessWidget {
  const _SplashPage();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
