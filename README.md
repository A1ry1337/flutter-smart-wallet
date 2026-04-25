# Flutter Smart Wallet Balanced

Это средний вариант архитектуры: не один файл, но и не сложный enterprise-шаблон.

## Что уже работает

- регистрация через `POST /api/auth/register`;
- вход через `POST /api/auth/login`;
- выход через `POST /api/auth/logout`;
- автоматический refresh через `POST /api/auth/refresh`;
- проверка защищённого endpoint `GET /test/get_user_from_jwt`;
- refresh token и access token сохраняются через `TokenStorage`;
- если защищённый запрос вернул `401` или `403`, приложение пробует обновить токены и повторить запрос.

## Структура

```text
lib/
  main.dart
  app.dart

  core/
    config/          # настройки приложения
    errors/          # общие ошибки
    network/         # общий API client
    storage/         # хранение токенов

  features/
    auth/
      data/          # AuthApi, AuthRepository
      models/        # AuthSession
      state/         # AuthController на ChangeNotifier
      ui/            # экран логина/реги

    home/
      data/          # UserApi
      ui/            # домашний экран

  shared/
    ui/              # переиспользуемые UI-компоненты
```

## Почему так

- `ui` не знает, как именно ходить в backend;
- `state` управляет состоянием экрана;
- `repository` решает бизнес-логику авторизации;
- `api` знает конкретные URL backend;
- `core/network` централизованно добавляет JWT и обновляет токены.

Так потом легко добавить фичи:

```text
features/cards/
features/profile/
features/transactions/
features/settings/
```

И внутри каждой фичи делать такие же папки: `data`, `models`, `state`, `ui`.

## Запуск в браузере

```bash
flutter create .
flutter pub get
flutter run -d chrome --web-port=5173 --dart-define=API_BASE_URL=http://localhost:8080
```

Открыть:

```text
http://localhost:5173
```

Backend должен быть запущен на:

```text
http://localhost:8080
```

## Если запросы из браузера блокируются

Добавь CORS-конфиг в Spring Boot. Пример лежит здесь:

```text
backend_examples/CorsConfig.java
```

## Важно про токены

Для простого запуска в браузере используется `shared_preferences`.

Для настоящего production web лучше хранить refresh token не в local storage, а в `HttpOnly Secure SameSite` cookie на backend-стороне.

Для мобильной версии можно заменить только реализацию `TokenStorage`, не трогая остальную архитектуру.
