import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kliensy/core/router/app_routes.dart';
import 'package:kliensy/features/auth/state/auth_controller.dart';
import 'package:kliensy/features/requests/models/comment_model.dart';
import 'package:kliensy/features/requests/models/request_model.dart';
import 'package:kliensy/features/requests/state/requests_controller.dart';
import 'package:kliensy/shared/ui/app_shell.dart';


class RequestDetailPage extends StatefulWidget {
  const RequestDetailPage({
    super.key,
    required this.requestId,
    required this.requestsController,
    required this.authController,
  });

  final int requestId;
  final RequestsController requestsController;
  final AuthController authController;

  @override
  State<RequestDetailPage> createState() => _RequestDetailPageState();
}

class _RequestDetailPageState extends State<RequestDetailPage> {
  final _commentController = TextEditingController();
  final _scrollController = ScrollController();

  RequestsController get _rc => widget.requestsController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _rc.loadDetail(widget.requestId);
    });
  }

  @override
  void dispose() {
    _commentController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendComment() async {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;

    _commentController.clear();
    await _rc.addComment(widget.requestId, text);

    // scroll to bottom
    await Future.delayed(const Duration(milliseconds: 100));
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _delete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Удалить заявку?'),
        content:
        const Text('Это действие невозможно отменить.'),
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
      await _rc.deleteRequest(widget.requestId);
      if (mounted) context.go(AppRoutes.requests);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 768;

    return AppShell(
      activeTab: AppTab.requests,
      authController: widget.authController,
      child: AnimatedBuilder(
        animation: _rc,
        builder: (_, __) {
          if (_rc.isDetailLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (_rc.detailError != null) {
            return Center(
              child: Text(_rc.detailError!,
                  style: const TextStyle(color: Colors.red)),
            );
          }

          final request = _rc.detailRequest;
          if (request == null) return const SizedBox.shrink();

          if (isMobile) {
            return _MobileDetail(
              request: request,
              comments: _rc.comments,
              commentController: _commentController,
              scrollController: _scrollController,
              onSendComment: _sendComment,
              onDelete: _delete,
              onStatusChange: (s) =>
                  _rc.changeStatus(widget.requestId, s),
              isSubmitting: _rc.isSubmitting,
            );
          }

          return _DesktopDetail(
            request: request,
            comments: _rc.comments,
            commentController: _commentController,
            scrollController: _scrollController,
            onSendComment: _sendComment,
            onDelete: _delete,
            onStatusChange: (s) =>
                _rc.changeStatus(widget.requestId, s),
            isSubmitting: _rc.isSubmitting,
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Mobile Detail
// ─────────────────────────────────────────────────────────────────────────────

class _MobileDetail extends StatelessWidget {
  const _MobileDetail({
    required this.request,
    required this.comments,
    required this.commentController,
    required this.scrollController,
    required this.onSendComment,
    required this.onDelete,
    required this.onStatusChange,
    required this.isSubmitting,
  });

  final RequestModel request;
  final List<CommentModel> comments;
  final TextEditingController commentController;
  final ScrollController scrollController;
  final VoidCallback onSendComment;
  final VoidCallback onDelete;
  final ValueChanged<RequestStatus> onStatusChange;
  final bool isSubmitting;

  String _formatTime(DateTime dt) {
    final now = DateTime.now();
    final isToday =
        dt.year == now.year && dt.month == now.month && dt.day == now.day;
    if (isToday) {
      return 'Сегодня ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    }
    return '${dt.day.toString().padLeft(2, '0')}.${dt.month.toString().padLeft(2, '0')}.${dt.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.go(AppRoutes.requests),
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1A1D2E)),
        ),
        title: Text(
          '№${request.id}',
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1D2E),
          ),
        ),
        actions: [
          OutlinedButton(
            onPressed: onDelete,
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red,
              side: const BorderSide(color: Colors.red),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Удалить заявку'),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              controller: scrollController,
              padding: const EdgeInsets.all(16),
              children: [
                // Client info
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFEEF2FF),
                      ),
                      child: const Icon(Icons.person_rounded,
                          color: Color(0xFF1A5BFF), size: 26),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            request.clientName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (request.clientPhone != null)
                            Text(
                              request.clientPhone!,
                              style: const TextStyle(
                                  fontSize: 14, color: Color(0xFF6B7280)),
                            ),
                        ],
                      ),
                    ),
                    if (request.clientPhone != null)
                      IconButton(
                        icon: const Icon(Icons.phone_rounded,
                            color: Color(0xFF1A5BFF)),
                        onPressed: () {},
                      ),
                  ],
                ),
                const SizedBox(height: 20),

                // Description
                const Text('Описание',
                    style: TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                Text(
                  request.description ?? request.title,
                  style: const TextStyle(
                      fontSize: 14, color: Color(0xFF374151), height: 1.5),
                ),
                const SizedBox(height: 20),

                // Status
                const Text('Статус',
                    style: TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w600)),
                const SizedBox(height: 10),
                _StatusSelector(
                  current: request.status,
                  onChanged: onStatusChange,
                  isLoading: isSubmitting,
                ),
                const SizedBox(height: 20),

                // Meta
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Создана',
                              style: TextStyle(
                                  fontSize: 12, color: Color(0xFF9CA3AF))),
                          Text(_formatTime(request.createdAt),
                              style: const TextStyle(fontSize: 14)),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Создал',
                              style: TextStyle(
                                  fontSize: 12, color: Color(0xFF9CA3AF))),
                          Text(request.createdByName ?? '—',
                              style: const TextStyle(fontSize: 14)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Comments
                const Text('Комментарии',
                    style: TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w600)),
                const SizedBox(height: 10),
                ...comments.map((c) => _CommentTile(comment: c)),
              ],
            ),
          ),
          // Comment input
          _CommentInput(
            controller: commentController,
            onSend: onSendComment,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Desktop Detail
// ─────────────────────────────────────────────────────────────────────────────

class _DesktopDetail extends StatelessWidget {
  const _DesktopDetail({
    required this.request,
    required this.comments,
    required this.commentController,
    required this.scrollController,
    required this.onSendComment,
    required this.onDelete,
    required this.onStatusChange,
    required this.isSubmitting,
  });

  final RequestModel request;
  final List<CommentModel> comments;
  final TextEditingController commentController;
  final ScrollController scrollController;
  final VoidCallback onSendComment;
  final VoidCallback onDelete;
  final ValueChanged<RequestStatus> onStatusChange;
  final bool isSubmitting;

  String _formatDateTime(DateTime dt) {
    return '${dt.day.toString().padLeft(2, '0')}.${dt.month.toString().padLeft(2, '0')}.${dt.year} '
        '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header
        Container(
          color: Colors.white,
          padding:
          const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          child: Row(
            children: [
              IconButton(
                onPressed: () => context.go(AppRoutes.requests),
                icon: const Icon(Icons.arrow_back_rounded,
                    color: Color(0xFF6B7280)),
              ),
              const SizedBox(width: 8),
              Text(
                'Заявка №${request.id}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              OutlinedButton.icon(
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline, size: 18),
                label: const Text('Удалить заявку'),
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
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left: main info
              Expanded(
                flex: 3,
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(24),
                  children: [
                    _InfoCard(
                      title: 'Клиент',
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFFEEF2FF),
                            ),
                            child: const Icon(Icons.person_rounded,
                                color: Color(0xFF1A5BFF), size: 24),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(request.clientName,
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600)),
                              if (request.clientPhone != null)
                                Text(request.clientPhone!,
                                    style: const TextStyle(
                                        fontSize: 13,
                                        color: Color(0xFF6B7280))),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    _InfoCard(
                      title: 'Описание',
                      child: Text(
                        request.description ?? request.title,
                        style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF374151),
                            height: 1.6),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _InfoCard(
                      title: 'Статус',
                      child: _StatusSelector(
                        current: request.status,
                        onChanged: onStatusChange,
                        isLoading: isSubmitting,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _InfoCard(
                      title: 'Информация',
                      child: Table(
                        children: [
                          TableRow(children: [
                            const Text('Создана',
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF9CA3AF))),
                            Text(request.createdByName ?? '—',
                                style: const TextStyle(fontSize: 13)),
                          ]),
                          const TableRow(children: [
                            SizedBox(height: 8),
                            SizedBox(height: 8),
                          ]),
                          TableRow(children: [
                            const Text('Дата',
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF9CA3AF))),
                            Text(_formatDateTime(request.createdAt),
                                style: const TextStyle(fontSize: 13)),
                          ]),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const VerticalDivider(width: 1),
              // Right: comments
              SizedBox(
                width: 380,
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(20),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Комментарии',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const Divider(height: 1),
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.all(16),
                        children: comments
                            .map((c) => _CommentTile(comment: c))
                            .toList(),
                      ),
                    ),
                    const Divider(height: 1),
                    _CommentInput(
                      controller: commentController,
                      onSend: onSendComment,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Reusable sub-widgets
// ─────────────────────────────────────────────────────────────────────────────

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.title, required this.child});
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF0F0F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF9CA3AF),
            ),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}

class _StatusSelector extends StatelessWidget {
  const _StatusSelector({
    required this.current,
    required this.onChanged,
    required this.isLoading,
  });

  final RequestStatus current;
  final ValueChanged<RequestStatus> onChanged;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const SizedBox(
        height: 36,
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      );
    }

    return Row(
      children: RequestStatus.values.map((status) {
        final isActive = current == status;
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: GestureDetector(
            onTap: () => onChanged(status),
            child: Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: isActive
                    ? const Color(0xFF1A5BFF)
                    : const Color(0xFFF4F6FB),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                status.label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: isActive ? Colors.white : const Color(0xFF6B7280),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _CommentTile extends StatelessWidget {
  const _CommentTile({required this.comment});
  final CommentModel comment;

  String _formatTime(DateTime dt) {
    final now = DateTime.now();
    final isToday =
        dt.year == now.year && dt.month == now.month && dt.day == now.day;
    if (isToday) {
      return 'Сегодня ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    }
    return '${dt.day.toString().padLeft(2, '0')}.${dt.month.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFEEF2FF),
            ),
            child: const Icon(Icons.person_rounded,
                color: Color(0xFF1A5BFF), size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      comment.authorName,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      _formatTime(comment.createdAt),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF9CA3AF),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  comment.text,
                  style: const TextStyle(
                      fontSize: 13, color: Color(0xFF374151), height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CommentInput extends StatelessWidget {
  const _CommentInput({
    required this.controller,
    required this.onSend,
  });

  final TextEditingController controller;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(
        left: 16,
        right: 8,
        top: 10,
        bottom: 10 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'Напишите комментарий',
                hintStyle:
                const TextStyle(color: Color(0xFFB0B7C3), fontSize: 14),
                filled: true,
                fillColor: const Color(0xFFF4F6FB),
                contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
              onSubmitted: (_) => onSend(),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF1A5BFF),
            ),
            child: IconButton(
              onPressed: onSend,
              icon: const Icon(Icons.send_rounded,
                  color: Colors.white, size: 18),
            ),
          ),
        ],
      ),
    );
  }
}