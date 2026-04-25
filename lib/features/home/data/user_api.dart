import '../../../core/network/api_client.dart';

class UserApi {
  UserApi(this._apiClient);

  final ApiClient _apiClient;

  Future<Map<String, dynamic>> getUserFromJwt() async {
    final response = await _apiClient.get('/test/get_user_from_jwt');

    if (response is Map<String, dynamic>) {
      return response;
    }

    return <String, dynamic>{};
  }
}
