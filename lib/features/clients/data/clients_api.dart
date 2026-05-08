

import 'package:kliensy/core/models/PagedResponse.dart';
import 'package:kliensy/core/network/api_client.dart';
import 'package:kliensy/features/clients/models/client_model.dart';

class ClientsApi {
  ClientsApi(this._apiClient);

  final ApiClient _apiClient;

  Future<PagedResponse<ClientModel>> getClients({
    int page = 0,
    String? search,
  }) async {
    final params = StringBuffer('/api/clients?page=$page');
    if (search != null && search.isNotEmpty) {
      params.write('&search=${Uri.encodeQueryComponent(search)}');
    }

    final response = await _apiClient.get(params.toString());
    return PagedResponse.fromJson(
      response as Map<String, dynamic>,
      ClientModel.fromJson,
    );
  }

  Future<ClientModel> getClient(int id) async {
    final response = await _apiClient.get('/api/clients/$id');
    return ClientModel.fromJson(response as Map<String, dynamic>);
  }

  Future<ClientModel> createClient({
    required String name,
    required String phone,
    String? comment,
  }) async {
    final response = await _apiClient.post(
      '/api/clients',
      body: {
        'name': name,
        'phone': phone,
        if (comment != null && comment.isNotEmpty) 'comment': comment,
      },
    );
    return ClientModel.fromJson(response as Map<String, dynamic>);
  }

  Future<ClientModel> updateClient(
      int id, {
        required String name,
        required String phone,
        String? comment,
      }) async {
    final response = await _apiClient.put(
      '/api/clients/$id',
      body: {
        'name': name,
        'phone': phone,
        if (comment != null) 'comment': comment,
      },
    );
    return ClientModel.fromJson(response as Map<String, dynamic>);
  }

  Future<void> deleteClient(int id) async {
    await _apiClient.delete('/api/clients/$id');
  }
}