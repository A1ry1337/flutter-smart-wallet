import 'package:flutter/foundation.dart';
import 'package:kliensy/core/errors/app_exception.dart';
import 'package:kliensy/features/requests/data/requests_api.dart';
import 'package:kliensy/features/requests/models/comment_model.dart';
import 'package:kliensy/features/requests/models/request_model.dart';


enum RequestsTab { all, newRequests, inProgress, done }

class RequestsController extends ChangeNotifier {
  RequestsController(this._api);

  final RequestsApi _api;

  // ── List state ────────────────────────────────────────────────────────────
  List<RequestModel> items = [];
  bool isLoading = false;
  bool isLoadingMore = false;
  String? listError;
  int currentPage = 0;
  int totalPages = 1;
  int totalElements = 0;
  RequestsTab activeTab = RequestsTab.all;
  String searchQuery = '';

  // Count cache per tab
  int countAll = 0;
  int countNew = 0;
  int countInProgress = 0;
  int countDone = 0;

  // ── Detail state ──────────────────────────────────────────────────────────
  RequestModel? detailRequest;
  bool isDetailLoading = false;
  String? detailError;

  List<CommentModel> comments = [];
  bool isCommentsLoading = false;

  bool isSubmitting = false;
  String? submitError;

  // ── Helpers ───────────────────────────────────────────────────────────────
  RequestStatus? get _tabStatus => switch (activeTab) {
    RequestsTab.all => null,
    RequestsTab.newRequests => RequestStatus.newRequest,
    RequestsTab.inProgress => RequestStatus.inProgress,
    RequestsTab.done => RequestStatus.done,
  };

  bool get hasMore => currentPage < totalPages - 1;

  // ── List actions ──────────────────────────────────────────────────────────
  Future<void> load({bool refresh = false}) async {
    if (refresh) {
      currentPage = 0;
      items = [];
    }

    isLoading = true;
    listError = null;
    notifyListeners();

    try {
      final resp = await _api.getRequests(
        page: currentPage,
        status: _tabStatus,
        search: searchQuery.isEmpty ? null : searchQuery,
      );
      items = refresh ? resp.content : [...items, ...resp.content];
      totalPages = resp.totalPages;
      totalElements = resp.totalElements;

      // refresh counts for all tabs when loading "all"
      if (activeTab == RequestsTab.all && searchQuery.isEmpty) {
        countAll = resp.totalElements;
      }
    } on AppException catch (e) {
      listError = e.message;
    } catch (_) {
      listError = 'Не удалось загрузить заявки';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadCounts() async {
    try {
      final futures = await Future.wait([
        _api.getRequests(page: 0),
        _api.getRequests(page: 0, status: RequestStatus.newRequest),
        _api.getRequests(page: 0, status: RequestStatus.inProgress),
        _api.getRequests(page: 0, status: RequestStatus.done),
      ]);
      countAll = futures[0].totalElements;
      countNew = futures[1].totalElements;
      countInProgress = futures[2].totalElements;
      countDone = futures[3].totalElements;
      notifyListeners();
    } catch (_) {}
  }

  Future<void> loadMore() async {
    if (!hasMore || isLoadingMore) return;
    currentPage++;
    isLoadingMore = true;
    notifyListeners();

    try {
      final resp = await _api.getRequests(
        page: currentPage,
        status: _tabStatus,
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

  void setTab(RequestsTab tab) {
    if (activeTab == tab) return;
    activeTab = tab;
    load(refresh: true);
  }

  void setSearch(String query) {
    searchQuery = query;
    load(refresh: true);
  }

  // ── Detail actions ────────────────────────────────────────────────────────
  Future<void> loadDetail(int id) async {
    isDetailLoading = true;
    detailError = null;
    detailRequest = null;
    notifyListeners();

    try {
      detailRequest = await _api.getRequest(id);
      await _loadComments(id);
    } on AppException catch (e) {
      detailError = e.message;
    } catch (_) {
      detailError = 'Не удалось загрузить заявку';
    } finally {
      isDetailLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadComments(int requestId) async {
    isCommentsLoading = true;
    notifyListeners();
    try {
      comments = await _api.getComments(requestId);
    } catch (_) {
      comments = [];
    } finally {
      isCommentsLoading = false;
      notifyListeners();
    }
  }

  Future<bool> changeStatus(int requestId, RequestStatus newStatus) async {
    isSubmitting = true;
    submitError = null;
    notifyListeners();

    try {
      final updated = await _api.patchStatus(requestId, newStatus);
      detailRequest = updated;

      // update in list
      items = items.map((r) => r.id == requestId ? updated : r).toList();
      notifyListeners();
      return true;
    } on AppException catch (e) {
      submitError = e.message;
      notifyListeners();
      return false;
    } catch (_) {
      submitError = 'Не удалось изменить статус';
      notifyListeners();
      return false;
    } finally {
      isSubmitting = false;
      notifyListeners();
    }
  }

  Future<bool> createRequest({
    required int clientId,
    required String title,
    String? description,
  }) async {
    isSubmitting = true;
    submitError = null;
    notifyListeners();

    try {
      await _api.createRequest(
        clientId: clientId,
        title: title,
        description: description,
      );
      await load(refresh: true);
      await loadCounts();
      return true;
    } on AppException catch (e) {
      submitError = e.message;
      notifyListeners();
      return false;
    } catch (_) {
      submitError = 'Не удалось создать заявку';
      notifyListeners();
      return false;
    } finally {
      isSubmitting = false;
      notifyListeners();
    }
  }

  Future<bool> deleteRequest(int id) async {
    isSubmitting = true;
    submitError = null;
    notifyListeners();

    try {
      await _api.deleteRequest(id);
      items = items.where((r) => r.id != id).toList();
      await loadCounts();
      notifyListeners();
      return true;
    } on AppException catch (e) {
      submitError = e.message;
      notifyListeners();
      return false;
    } catch (_) {
      submitError = 'Не удалось удалить заявку';
      notifyListeners();
      return false;
    } finally {
      isSubmitting = false;
      notifyListeners();
    }
  }

  Future<bool> addComment(int requestId, String text) async {
    try {
      final comment = await _api.addComment(requestId, text);
      comments = [...comments, comment];
      notifyListeners();
      return true;
    } catch (_) {
      return false;
    }
  }

  void clearDetail() {
    detailRequest = null;
    detailError = null;
    comments = [];
    submitError = null;
  }
}