import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/state/auth_controller.dart';
import '../../features/auth/ui/auth_page.dart';
import '../../features/home/data/user_api.dart';
import '../../features/home/ui/home_page.dart';
import '../errors/app_exception.dart';
import 'app_routes.dart';

/// Фабрика роутера.
///
/// Принимает зависимости явно — никакого глобального состояния.
/// При смене [AuthStatus] go_router сам пересчитывает редиректы через
/// [GoRouter.refreshListenable].
GoRouter createRouter({
  required AuthController authController,
  required UserApi userApi,
}) {
  return GoRouter(
    debugLogDiagnostics: true,
    initialLocation: AppRoutes.splash,
    refreshListenable: authController,   // перерисовка guard при смене auth-статуса
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

      // ── Protected ────────────────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.home,
        builder: (_, __) => HomePage(
          authController: authController,
          userApi: userApi,
        ),
      ),

      // Пример как легко добавить новые защищённые маршруты:
      //
      // GoRoute(
      //   path: AppRoutes.cards,
      //   builder: (_, __) => CardsPage(...),
      //   routes: [
      //     GoRoute(
      //       path: ':id',
      //       builder: (_, state) => CardDetailPage(id: state.pathParameters['id']!),
      //     ),
      //   ],
      // ),
    ],

    // Централизованная обработка ошибок навигации
    errorBuilder: (_, state) => _RouterErrorPage(error: state.error),
  );
}

/// Auth-guard: решает куда редиректить при каждом переходе.
///
/// Логика:
/// - [checking]        → всегда на splash (идёт восстановление сессии)
/// - [unauthenticated] → закрытые маршруты перекидываем на /login
/// - [authenticated]   → открытые маршруты перекидываем на /home
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
          ? AppRoutes.home
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
      return AppRoutes.home;
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
