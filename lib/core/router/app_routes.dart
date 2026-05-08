/// Централизованные имена и пути всех маршрутов приложения.
abstract final class AppRoutes {
  // Auth
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';

  // Main app (требуют авторизации)
  static const String home = '/home';
  static const String requests = '/requests';
  static const String requestDetail = '/requests/:id';
  static const String clients = '/clients';
  static const String clientDetail = '/clients/:id';
  static const String settings = '/settings';

  static String requestDetailPath(int id) => '/requests/$id';
  static String clientDetailPath(int id) => '/clients/$id';
}