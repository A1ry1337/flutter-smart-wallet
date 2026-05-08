import 'package:flutter/material.dart';

import 'core/router/app_router.dart';
import 'features/auth/state/auth_controller.dart';
import 'features/home/data/user_api.dart';
import 'features/requests/state/requests_controller.dart';
import 'features/clients/state/clients_controller.dart';

class KliensyApp extends StatefulWidget {
  const KliensyApp({
    super.key,
    required this.authController,
    required this.userApi,
    required this.requestsController,
    required this.clientsController,
  });

  final AuthController authController;
  final UserApi userApi;
  final RequestsController requestsController;
  final ClientsController clientsController;

  @override
  State<KliensyApp> createState() => _KliensyAppState();
}

class _KliensyAppState extends State<KliensyApp> {
  late final _router = createRouter(
    authController: widget.authController,
    userApi: widget.userApi,
    requestsController: widget.requestsController,
    clientsController: widget.clientsController,
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