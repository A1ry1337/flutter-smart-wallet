# Flutter Smart Wallet — с роутингом (go_router)

Тот же проект, но теперь с полноценным декларативным роутингом на [go_router](https://pub.dev/packages/go_router).

## Что изменилось

| До | После |
|----|-------|
| `switch` в `AnimatedBuilder` внутри `app.dart` | `GoRouter` с декларативными маршрутами |
| `MaterialApp(home: ...)` | `MaterialApp.router(routerConfig: _router)` |
| Один экран `/login+register` переключался setState | Два отдельных маршрута `/login` и `/register` |
| Навигация — прямая передача виджетов | `context.go(AppRoutes.xxx)` через константы |
| Auth-guard — нет | Auth-guard через `redirect` + `refreshListenable` |

## Новые файлы

```text
lib/core/router/
  app_routes.dart   — константы всех путей (единственное место с URL-строками)
  app_router.dart   — GoRouter + auth-guard redirect
```

## Как работает auth-guard

```
AuthController.notifyListeners()
       ↓
GoRouter.refreshListenable срабатывает
       ↓
redirect() вызывается для текущего маршрута
       ↓
checking       → /
unauthenticated + закрытый маршрут → /login
authenticated  + открытый маршрут  → /home
```

Ни один экран не делает `context.go` при смене статуса — роутер сам это замечает.

## Маршруты

| Путь        | Доступ            | Экран           |
|-------------|-------------------|-----------------|
| `/`         | всегда (сплеш)    | `_SplashPage`   |
| `/login`    | только неавторизованные | `AuthPage(login)` |
| `/register` | только неавторизованные | `AuthPage(register)` |
| `/home`     | только авторизованные | `HomePage`    |

## Как добавить новую фичу

1. Добавь константу в `app_routes.dart`:
   ```dart
   static const String cards = '/cards';
   ```

2. Добавь `GoRoute` в `app_router.dart`:
   ```dart
   GoRoute(
     path: AppRoutes.cards,
     builder: (_, __) => CardsPage(...),
   ),
   ```

3. Создай фичу по стандартной структуре:
   ```text
   features/cards/
     data/    — CardsApi, CardsRepository
     models/  — Card, ...
     state/   — CardsController
     ui/      — CardsPage
   ```

4. Навигация из любого виджета:
   ```dart
   context.go(AppRoutes.cards);
   context.push(AppRoutes.cards); // если нужна кнопка «назад»
   ```

## Что уже работает

- регистрация → `POST /api/auth/register`
- вход → `POST /api/auth/login`
- выход → `POST /api/auth/logout`
- авто-refresh → `POST /api/auth/refresh`
- защищённый endpoint → `GET /test/get_user_from_jwt`
- токены сохраняются через `TokenStorage`
- 401/403 → авто-retry с refresh, иначе forceLogout → guard редиректит на /login

## Запуск

```bash
flutter pub get
flutter run -d chrome --web-port=5173 --dart-define=API_BASE_URL=http://localhost:8080
```

## Структура

```text
lib/
  main.dart
  app.dart

  core/
    config/        — AppConfig
    errors/        — AppException, ApiException
    network/       — ApiClient (JWT + авто-refresh)
    router/        — app_routes.dart, app_router.dart  ← NEW
    storage/       — TokenStorage, SharedPrefsTokenStorage

  features/
    auth/
      data/        — AuthApi, AuthRepository
      models/      — AuthSession
      state/       — AuthController (ChangeNotifier + refreshListenable)
      ui/          — AuthPage (принимает initialMode)

    home/
      data/        — UserApi
      ui/          — HomePage

  shared/
    ui/            — AppButton, AppTextField
```