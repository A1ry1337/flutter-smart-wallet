
import 'package:kliensy/core/models/PagedResponse.dart';
import 'package:kliensy/core/network/api_client.dart';
import 'package:kliensy/features/requests/models/comment_model.dart';
import 'package:kliensy/features/requests/models/request_model.dart';

class RequestsApi {
  RequestsApi(this._apiClient);

  final ApiClient _apiClient;

  Future<PagedResponse<RequestModel>> getRequests({
    int page = 0,
    RequestStatus? status,
    String? search,
  }) async {
    final params = StringBuffer('/api/requests?page=$page');
    if (status != null) {
      params.write('&status=${status.toApiString()}');
    }
    if (search != null && search.isNotEmpty) {
      params.write('&search=${Uri.encodeQueryComponent(search)}');
    }

    final response = await _apiClient.get(params.toString());
    return PagedResponse.fromJson(
      response as Map<String, dynamic>,
      RequestModel.fromJson,
    );
  }

  Future<RequestModel> getRequest(int id) async {
    final response = await _apiClient.get('/api/requests/$id');
    return RequestModel.fromJson(response as Map<String, dynamic>);
  }

  Future<PagedResponse<RequestModel>> getRequestsByClient(
      int clientId, {
        int page = 0,
      }) async {
    final response = await _apiClient
        .get('/api/requests/by-client/$clientId?page=$page');
    return PagedResponse.fromJson(
      response as Map<String, dynamic>,
      RequestModel.fromJson,
    );
  }

  Future<RequestModel> createRequest({
    required int clientId,
    required String title,
    String? description,
  }) async {
    final response = await _apiClient.post(
      '/api/requests',
      body: {
        'clientId': clientId,
        'title': title,
        if (description != null && description.isNotEmpty)
          'description': description,
      },
    );
    return RequestModel.fromJson(response as Map<String, dynamic>);
  }

  Future<RequestModel> updateRequest(
      int id, {
        String? title,
        String? description,
        RequestStatus? status,
      }) async {
    final body = <String, dynamic>{};
    if (title != null) body['title'] = title;
    if (description != null) body['description'] = description;
    if (status != null) body['status'] = status.toApiString();

    final response = await _apiClient.put('/api/requests/$id', body: body);
    return RequestModel.fromJson(response as Map<String, dynamic>);
  }

  Future<RequestModel> patchStatus(int id, RequestStatus status) async {
    final response = await _apiClient.patch(
      '/api/requests/$id/status?status=${status.toApiString()}',
    );
    return RequestModel.fromJson(response as Map<String, dynamic>);
  }

  Future<void> deleteRequest(int id) async {
    await _apiClient.delete('/api/requests/$id');
  }

  Future<List<CommentModel>> getComments(int requestId) async {
    final response = await _apiClient.get('/api/requests/$requestId/comments');
    final list = response as List<dynamic>;
    return list
        .map((e) => CommentModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<CommentModel> addComment(int requestId, String text) async {
    final response = await _apiClient.post(
      '/api/requests/$requestId/comments',
      body: {'text': text},
    );
    return CommentModel.fromJson(response as Map<String, dynamic>);
  }
}