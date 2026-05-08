import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:kliensy/core/errors/app_exception.dart';
import 'package:kliensy/core/storage/token_storage.dart';


class ApiClient {
  ApiClient({
    required String baseUrl,
    required TokenStorage tokenStorage,
    http.Client? httpClient,
  })  : _baseUrl = baseUrl.endsWith('/')
      ? baseUrl.substring(0, baseUrl.length - 1)
      : baseUrl,
        _tokenStorage = tokenStorage,
        _httpClient = httpClient ?? http.Client();

  final String _baseUrl;
  final TokenStorage _tokenStorage;
  final http.Client _httpClient;

  Future<dynamic> get(String path, {bool auth = true}) =>
      _request('GET', path, auth: auth);

  Future<dynamic> post(String path,
      {Map<String, dynamic>? body, bool auth = true}) =>
      _request('POST', path, body: body, auth: auth);

  Future<dynamic> put(String path,
      {Map<String, dynamic>? body, bool auth = true}) =>
      _request('PUT', path, body: body, auth: auth);

  Future<dynamic> patch(String path,
      {Map<String, dynamic>? body, bool auth = true}) =>
      _request('PATCH', path, body: body, auth: auth);

  Future<dynamic> delete(String path, {bool auth = true}) =>
      _request('DELETE', path, auth: auth);

  Future<dynamic> _request(
      String method,
      String path, {
        Map<String, dynamic>? body,
        required bool auth,
        bool retryAfterRefresh = true,
      }) async {
    final response = await _send(method, path, body: body, auth: auth);

    if (_isSuccess(response.statusCode)) {
      return _decode(response);
    }

    final shouldRefresh = auth &&
        retryAfterRefresh &&
        (response.statusCode == 401 || response.statusCode == 403);

    if (shouldRefresh) {
      final refreshed = await _refreshTokens();
      if (refreshed) {
        final secondResponse =
        await _send(method, path, body: body, auth: auth);
        if (_isSuccess(secondResponse.statusCode)) {
          return _decode(secondResponse);
        }
        throw _exceptionFromResponse(secondResponse);
      }
    }

    throw _exceptionFromResponse(response);
  }

  Future<http.Response> _send(
      String method,
      String path, {
        Map<String, dynamic>? body,
        required bool auth,
      }) async {
    final uri = Uri.parse('$_baseUrl${path.startsWith('/') ? path : '/$path'}');
    final headers = <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    if (auth) {
      final accessToken = await _tokenStorage.getAccessToken();
      if (accessToken != null && accessToken.isNotEmpty) {
        headers['Authorization'] = 'Bearer $accessToken';
      }
    }

    final encodedBody = body == null ? null : jsonEncode(body);

    return switch (method) {
      'GET' => _httpClient.get(uri, headers: headers),
      'POST' => _httpClient.post(uri, headers: headers, body: encodedBody),
      'PUT' => _httpClient.put(uri, headers: headers, body: encodedBody),
      'PATCH' => _httpClient.patch(uri, headers: headers, body: encodedBody),
      'DELETE' => _httpClient.delete(uri, headers: headers),
      _ => throw ApiException('Метод $method не поддержан'),
    };
  }

  Future<bool> _refreshTokens() async {
    final refreshToken = await _tokenStorage.getRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      await _tokenStorage.clear();
      return false;
    }

    final uri = Uri.parse('$_baseUrl/api/auth/refresh');
    final response = await _httpClient.post(
      uri,
      headers: const {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'refreshToken': refreshToken}),
    );

    if (!_isSuccess(response.statusCode)) {
      await _tokenStorage.clear();
      return false;
    }

    final decoded = _decode(response);
    if (decoded is! Map<String, dynamic>) {
      await _tokenStorage.clear();
      return false;
    }

    final newAccessToken = decoded['accessToken'] as String?;
    final newRefreshToken = decoded['refreshToken'] as String?;

    if (newAccessToken == null || newRefreshToken == null) {
      await _tokenStorage.clear();
      return false;
    }

    await _tokenStorage.saveTokens(
      accessToken: newAccessToken,
      refreshToken: newRefreshToken,
    );
    return true;
  }

  bool _isSuccess(int statusCode) => statusCode >= 200 && statusCode < 300;

  dynamic _decode(http.Response response) {
    final text = utf8.decode(response.bodyBytes);
    if (text.isEmpty) return null;
    return jsonDecode(text);
  }

  ApiException _exceptionFromResponse(http.Response response) {
    final text = utf8.decode(response.bodyBytes);
    String message = 'Ошибка запроса: ${response.statusCode}';

    if (text.isNotEmpty) {
      try {
        final decoded = jsonDecode(text);
        if (decoded is Map<String, dynamic>) {
          message = decoded['message']?.toString() ??
              decoded['error']?.toString() ??
              decoded['detail']?.toString() ??
              message;
        } else {
          message = text;
        }
      } catch (_) {
        message = text;
      }
    }

    return ApiException(message, statusCode: response.statusCode);
  }
}