import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kliensy/core/errors/app_exception.dart';
import 'package:kliensy/features/auth/state/auth_controller.dart';
import 'package:kliensy/features/auth/ui/auth_page.dart';
import 'package:kliensy/features/clients/state/clients_controller.dart';
import 'package:kliensy/features/clients/ui/%20clients_page.dart';
import 'package:kliensy/features/clients/ui/client_detail_page.dart';
import 'package:kliensy/features/home/data/user_api.dart';
import 'package:kliensy/features/home/ui/home_page.dart';
import 'package:kliensy/features/requests/state/requests_controller.dart';
import 'package:kliensy/features/requests/ui/%20request_detail_page.dart';
import 'package:kliensy/features/requests/ui/requests_page.dart';
import 'package:kliensy/features/settings/ui/settings_page.dart';


import 'app_routes.dart';

/// Фабрика роутера.
///
/// Принимает зависимости явно — никакого глобального состояния.
/// При смене [AuthStatus] go_router сам пересчитывает редиректы через
/// [GoRouter.refreshListenable].
GoRouter createRouter({
  required AuthController authController,
  required UserApi userApi,
  required RequestsController requestsController,
  required ClientsController clientsController,
}) {
  return GoRouter(
    debugLogDiagnostics: true,
    initialLocation: AppRoutes.splash,
    refreshListenable: authController,
    redirect: _authGuard(authController),
    routes: [
      // ── Splash ──────────────────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.splash,
        builder: (_, __) => const _SplashPage(),
      ),

      // ── Auth ─────────────────────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.login,
        builder: (_, __) => AuthPage(
          authController: authController,
          initialMode: AuthMode.login,
        ),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (_, __) => AuthPage(
          authController: authController,
          initialMode: AuthMode.register,
        ),
      ),

      // ── Protected / legacy home ──────────────────────────────────────────
      GoRoute(
        path: AppRoutes.home,
        builder: (_, __) => HomePage(
          authController: authController,
          userApi: userApi,
        ),
      ),

      // ── Requests ─────────────────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.requests,
        builder: (_, __) => RequestsPage(
          requestsController: requestsController,
          authController: authController,
        ),
      ),
      GoRoute(
        path: AppRoutes.requestDetail,
        builder: (_, state) {
          final id = int.tryParse(state.pathParameters['id'] ?? '');

          if (id == null) {
            return const _RouterErrorPage(
              error: AppException('Некорректный ID заявки'),
            );
          }

          return RequestDetailPage(
            requestId: id,
            requestsController: requestsController,
            authController: authController,
          );
        },
      ),

      // ── Clients ──────────────────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.clients,
        builder: (_, __) => ClientsPage(
          clientsController: clientsController,
          authController: authController,
        ),
      ),
      GoRoute(
        path: AppRoutes.clientDetail,
        builder: (_, state) {
          final id = int.tryParse(state.pathParameters['id'] ?? '');

          if (id == null) {
            return const _RouterErrorPage(
              error: AppException('Некорректный ID клиента'),
            );
          }

          return ClientDetailPage(
            clientId: id,
            clientsController: clientsController,
            requestsController: requestsController,
            authController: authController,
          );
        },
      ),

      // ── Settings ─────────────────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.settings,
        builder: (_, __) => SettingsPage(
          authController: authController,
        ),
      ),
    ],

    errorBuilder: (_, state) => _RouterErrorPage(error: state.error),
  );
}

/// Auth-guard: решает куда редиректить при каждом переходе.
GoRouterRedirect _authGuard(AuthController authController) {
  return (BuildContext context, GoRouterState state) {
    final status = authController.status;
    final location = state.matchedLocation;

    // 1. Пока checking → всегда splash
    if (status == AuthStatus.checking) {
      return location == AppRoutes.splash ? null : AppRoutes.splash;
    }

    // 2. После проверки — уходим со splash
    if (location == AppRoutes.splash) {
      return status == AuthStatus.authenticated
          ? AppRoutes.requests
          : AppRoutes.login;
    }

    final isOnAuthPage =
        location == AppRoutes.login || location == AppRoutes.register;

    // 3. Не авторизован → только login/register
    if (status == AuthStatus.unauthenticated && !isOnAuthPage) {
      return AppRoutes.login;
    }

    // 4. Авторизован → не пускаем на login/register
    if (status == AuthStatus.authenticated && isOnAuthPage) {
      return AppRoutes.requests;
    }

    return null;
  };
}

// ── Вспомогательные виджеты роутера ─────────────────────────────────────────

class _SplashPage extends StatelessWidget {
  const _SplashPage();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}

class _RouterErrorPage extends StatelessWidget {
  const _RouterErrorPage({required this.error});

  final Exception? error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          error is AppException
              ? (error as AppException).message
              : 'Страница не найдена',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
    );
  }
}