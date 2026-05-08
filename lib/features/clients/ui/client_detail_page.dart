import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kliensy/core/router/app_routes.dart';
import 'package:kliensy/features/auth/state/auth_controller.dart';
import 'package:kliensy/features/clients/models/client_model.dart';
import 'package:kliensy/features/clients/state/clients_controller.dart';
import 'package:kliensy/features/requests/data/requests_api.dart';
import 'package:kliensy/features/requests/models/request_model.dart';
import 'package:kliensy/features/requests/state/requests_controller.dart';
import 'package:kliensy/shared/ui/app_shell.dart';
import 'package:kliensy/shared/ui/status_badge.dart';


class ClientDetailPage extends StatefulWidget {
  const ClientDetailPage({
    super.key,
    required this.clientId,
    required this.clientsController,
    required this.requestsController,
    required this.authController,
  });

  final int clientId;
  final ClientsController clientsController;
  final RequestsController requestsController;
  final AuthController authController;

  @override
  State<ClientDetailPage> createState() => _ClientDetailPageState();
}

class _ClientDetailPageState extends State<ClientDetailPage> {
  ClientsController get _cc => widget.clientsController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _cc.loadDetail(widget.clientId));
  }

  Future<void> _delete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Удалить клиента?'),
        content: const Text('Все заявки клиента останутся.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Отмена'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Удалить'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _cc.deleteClient(widget.clientId);
      if (mounted) context.go(AppRoutes.clients);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppShell(
      activeTab: AppTab.clients,
      authController: widget.authController,
      child: AnimatedBuilder(
        animation: _cc,
        builder: (_, __) {
          if (_cc.isDetailLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (_cc.detailError != null) {
            return Center(
                child: Text(_cc.detailError!,
                    style: const TextStyle(color: Colors.red)));
          }
          final client = _cc.detailClient;
          if (client == null) return const SizedBox.shrink();

          return _ClientDetailBody(
            client: client,
            requestsController: widget.requestsController,
            authController: widget.authController,
            onDelete: _delete,
          );
        },
      ),
    );
  }
}

class _ClientDetailBody extends StatefulWidget {
  const _ClientDetailBody({
    required this.client,
    required this.requestsController,
    required this.authController,
    required this.onDelete,
  });

  final ClientModel client;
  final RequestsController requestsController;
  final AuthController authController;
  final VoidCallback onDelete;

  @override
  State<_ClientDetailBody> createState() => _ClientDetailBodyState();
}

class _ClientDetailBodyState extends State<_ClientDetailBody> {
  List<RequestModel> _clientRequests = [];
  bool _loadingRequests = true;

  @override
  void initState() {
    super.initState();
    _loadRequests();
  }

  Future<void> _loadRequests() async {
    try {
      final resp = await widget.requestsController._api
          .getRequestsByClient(widget.client.id);
      if (mounted) {
        setState(() {
          _clientRequests = resp.content;
          _loadingRequests = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loadingRequests = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 768;

    return Column(
      children: [
        // Header
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Row(
            children: [
              if (!isMobile) ...[
                IconButton(
                  onPressed: () => context.go(AppRoutes.clients),
                  icon: const Icon(Icons.arrow_back_rounded,
                      color: Color(0xFF6B7280)),
                ),
                const SizedBox(width: 8),
              ] else
                IconButton(
                  onPressed: () => context.go(AppRoutes.clients),
                  icon: const Icon(Icons.arrow_back,
                      color: Color(0xFF1A1D2E)),
                ),
              Expanded(
                child: Text(
                  widget.client.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              OutlinedButton.icon(
                onPressed: widget.onDelete,
                icon: const Icon(Icons.delete_outline, size: 18),
                label: const Text('Удалить'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Client info card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFF0F0F0)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFEEF2FF),
                        ),
                        child: Center(
                          child: Text(
                            widget.client.name.isNotEmpty
                                ? widget.client.name[0].toUpperCase()
                                : '?',
                            style: const TextStyle(
                              color: Color(0xFF1A5BFF),
                              fontWeight: FontWeight.w700,
                              fontSize: 22,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.client.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.client.phone,
                              style: const TextStyle(
                                  fontSize: 14, color: Color(0xFF6B7280)),
                            ),
                            if (widget.client.comment != null) ...[
                              const SizedBox(height: 4),
                              Text(
                                widget.client.comment!,
                                style: const TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF9CA3AF)),
                              ),
                            ],
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.phone_rounded,
                            color: Color(0xFF1A5BFF)),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Заявки клиента',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                if (_loadingRequests)
                  const Center(child: CircularProgressIndicator())
                else if (_clientRequests.isEmpty)
                  const Text('Нет заявок',
                      style: TextStyle(color: Color(0xFF9CA3AF)))
                else
                  ...(_clientRequests.map(
                        (r) => _RequestMiniCard(request: r),
                  )),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _RequestMiniCard extends StatelessWidget {
  const _RequestMiniCard({required this.request});
  final RequestModel request;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go(AppRoutes.requestDetailPath(request.id)),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFF0F0F0)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    request.title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (request.description != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      request.description!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 13, color: Color(0xFF9CA3AF)),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 12),
            StatusBadge(status: request.status),
          ],
        ),
      ),
    );
  }
}

// Extension to expose _api from RequestsController for loading by client
extension RequestsControllerApi on RequestsController {
  RequestsApi get _api => (this as dynamic)._api as RequestsApi;
}