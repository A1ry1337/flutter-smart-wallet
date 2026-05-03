/// Централизованные имена и пути всех маршрутов приложения.
///
/// Добавляя новый экран — просто добавь сюда константу.
/// Так ни один [context.go] не будет опечаткой в строке.
abstract final class AppRoutes {
  // Auth
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';

  // Main app (требуют авторизации)
  static const String home = '/home';

  // Пример будущих маршрутов (раскомментируй при добавлении):
  // static const String cards        = '/cards';
  // static const String cardDetail   = '/cards/:id';
  // static const String transactions = '/transactions';
  // static const String profile      = '/profile';
  // static const String settings     = '/settings';
}
