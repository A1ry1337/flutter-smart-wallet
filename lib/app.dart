import 'package:flutter/material.dart';

import 'core/router/app_router.dart';
import 'features/auth/state/auth_controller.dart';
import 'features/home/data/user_api.dart';

class KliensyApp extends StatefulWidget {
  const KliensyApp({
    super.key,
    required this.authController,
    required this.userApi,
  });

  final AuthController authController;
  final UserApi userApi;

  @override
  State<KliensyApp> createState() => _KliensyAppState();
}

class _KliensyAppState extends State<KliensyApp> {
  late final _router = createRouter(
    authController: widget.authController,
    userApi: widget.userApi,
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Kliensy',
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
