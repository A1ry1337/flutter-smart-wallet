import 'package:flutter/foundation.dart';
import 'package:kliensy/core/errors/app_exception.dart';
import 'package:kliensy/features/clients/data/clients_api.dart';
import 'package:kliensy/features/clients/models/client_model.dart';


class ClientsController extends ChangeNotifier {
  ClientsController(this._api);

  final ClientsApi _api;

  // ── List state ────────────────────────────────────────────────────────────
  List<ClientModel> items = [];
  bool isLoading = false;
  bool isLoadingMore = false;
  String? listError;
  int currentPage = 0;
  int totalPages = 1;
  int totalElements = 0;
  String searchQuery = '';

  // ── Detail state ──────────────────────────────────────────────────────────
  ClientModel? detailClient;
  bool isDetailLoading = false;
  String? detailError;

  bool isSubmitting = false;
  String? submitError;

  bool get hasMore => currentPage < totalPages - 1;

  // ── Actions ───────────────────────────────────────────────────────────────
  Future<void> load({bool refresh = false}) async {
    if (refresh) {
      currentPage = 0;
      items = [];
    }

    isLoading = true;
    listError = null;
    notifyListeners();

    try {
      final resp = await _api.getClients(
        page: currentPage,
        search: searchQuery.isEmpty ? null : searchQuery,
      );
      items = refresh ? resp.content : [...items, ...resp.content];
      totalPages = resp.totalPages;
      totalElements = resp.totalElements;
    } on AppException catch (e) {
      listError = e.message;
    } catch (_) {
      listError = 'Не удалось загрузить клиентов';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMore() async {
    if (!hasMore || isLoadingMore) return;
    currentPage++;
    isLoadingMore = true;
    notifyListeners();

    try {
      final resp = await _api.getClients(
        page: currentPage,
        search: searchQuery.isEmpty ? null : searchQuery,
      );
      items = [...items, ...resp.content];
      totalPages = resp.totalPages;
    } catch (_) {
      currentPage--;
    } finally {
      isLoadingMore = false;
      notifyListeners();
    }
  }

  void setSearch(String query) {
    searchQuery = query;
    load(refresh: true);
  }

  Future<void> loadDetail(int id) async {
    isDetailLoading = true;
    detailError = null;
    detailClient = null;
    notifyListeners();

    try {
      detailClient = await _api.getClient(id);
    } on AppException catch (e) {
      detailError = e.message;
    } catch (_) {
      detailError = 'Не удалось загрузить клиента';
    } finally {
      isDetailLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createClient({
    required String name,
    required String phone,
    String? comment,
  }) async {
    isSubmitting = true;
    submitError = null;
    notifyListeners();

    try {
      await _api.createClient(name: name, phone: phone, comment: comment);
      await load(refresh: true);
      return true;
    } on AppException catch (e) {
      submitError = e.message;
      notifyListeners();
      return false;
    } catch (_) {
      submitError = 'Не удалось создать клиента';
      notifyListeners();
      return false;
    } finally {
      isSubmitting = false;
      notifyListeners();
    }
  }

  Future<bool> updateClient(
      int id, {
        required String name,
        required String phone,
        String? comment,
      }) async {
    isSubmitting = true;
    submitError = null;
    notifyListeners();

    try {
      final updated = await _api.updateClient(id,
          name: name, phone: phone, comment: comment);
      detailClient = updated;
      items = items.map((c) => c.id == id ? updated : c).toList();
      notifyListeners();
      return true;
    } on AppException catch (e) {
      submitError = e.message;
      notifyListeners();
      return false;
    } catch (_) {
      submitError = 'Не удалось обновить клиента';
      notifyListeners();
      return false;
    } finally {
      isSubmitting = false;
      notifyListeners();
    }
  }

  Future<bool> deleteClient(int id) async {
    isSubmitting = true;
    submitError = null;
    notifyListeners();

    try {
      await _api.deleteClient(id);
      items = items.where((c) => c.id != id).toList();
      notifyListeners();
      return true;
    } on AppException catch (e) {
      submitError = e.message;
      notifyListeners();
      return false;
    } catch (_) {
      submitError = 'Не удалось удалить клиента';
      notifyListeners();
      return false;
    } finally {
      isSubmitting = false;
      notifyListeners();
    }
  }

  void clearDetail() {
    detailClient = null;
    detailError = null;
    submitError = null;
  }
}