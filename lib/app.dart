import 'package:flutter/material.dart';

import 'core/router/app_router.dart';
import 'features/auth/state/auth_controller.dart';
import 'features/home/data/user_api.dart';

class SmartWalletApp extends StatefulWidget {
  const SmartWalletApp({
    super.key,
    required this.authController,
    required this.userApi,
  });

  final AuthController authController;
  final UserApi userApi;

  @override
  State<SmartWalletApp> createState() => _SmartWalletAppState();
}

class _SmartWalletAppState extends State<SmartWalletApp> {
  late final _router = createRouter(
    authController: widget.authController,
    userApi: widget.userApi,
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Smart Wallet',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
        ),
      ),
      routerConfig: _router,
    );
  }
}
