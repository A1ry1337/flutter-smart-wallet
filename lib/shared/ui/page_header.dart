import 'package:flutter/material.dart';

/// Верхняя шапка страницы: заголовок + поиск/кнопка + аватар.
/// Адаптируется под мобильный и десктоп.
class PageHeader extends StatelessWidget {
  const PageHeader({
    super.key,
    required this.title,
    this.searchHint,
    this.actionLabel,
    this.onAction,
    this.onSearch,
    this.searchController,
    this.breadcrumbs,
    this.userInitials = 'ИП',
  });

  final String title;
  final String? searchHint;
  final String? actionLabel;
  final VoidCallback? onAction;
  final ValueChanged<String>? onSearch;
  final TextEditingController? searchController;

  /// Если не null — вместо поиска показываем хлебные крошки.
  final List<Breadcrumb>? breadcrumbs;

  final String userInitials;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1D2E),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: breadcrumbs != null
                ? _BreadcrumbRow(breadcrumbs: breadcrumbs!)
                : _SearchRow(
              hint: searchHint ?? 'Поиск...',
              controller: searchController,
              onSearch: onSearch,
              actionLabel: actionLabel,
              onAction: onAction,
            ),
          ),
          const SizedBox(width: 16),
          _AvatarButton(initials: userInitials),
        ],
      ),
    );
  }
}

class Breadcrumb {
  const Breadcrumb({required this.label, this.onTap});
  final String label;
  final VoidCallback? onTap;
}

List<Breadcrumb> buildBreadcrumbs(List<(String, VoidCallback?)> items) =>
    items.map((e) => Breadcrumb(label: e.$1, onTap: e.$2)).toList();

class _BreadcrumbRow extends StatelessWidget {
  const _BreadcrumbRow({required this.breadcrumbs});
  final List<Breadcrumb> breadcrumbs;

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[];
    for (int i = 0; i < breadcrumbs.length; i++) {
      final crumb = breadcrumbs[i];
      final isLast = i == breadcrumbs.length - 1;

      items.add(
        GestureDetector(
          onTap: crumb.onTap,
          child: Text(
            crumb.label,
            style: TextStyle(
              fontSize: 14,
              color: isLast
                  ? const Color(0xFF1A1D2E)
                  : const Color(0xFF8B90A7),
              fontWeight:
              isLast ? FontWeight.w500 : FontWeight.w400,
              decoration: crumb.onTap != null && !isLast
                  ? TextDecoration.none
                  : null,
            ),
          ),
        ),
      );
      if (!isLast) {
        items.add(
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 6),
            child: Icon(Icons.chevron_right,
                size: 16, color: Color(0xFF8B90A7)),
          ),
        );
      }
    }

    return Row(children: items);
  }
}

class _SearchRow extends StatelessWidget {
  const _SearchRow({
    required this.hint,
    this.controller,
    this.onSearch,
    this.actionLabel,
    this.onAction,
  });

  final String hint;
  final TextEditingController? controller;
  final ValueChanged<String>? onSearch;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 40,
            child: TextField(
              controller: controller,
              onChanged: onSearch,
              style: const TextStyle(fontSize: 14),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFFB0B7C3),
                ),
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  size: 18,
                  color: Color(0xFFB0B7C3),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                filled: true,
                fillColor: const Color(0xFFF4F6FB),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Color(0xFF1A5BFF),
                    width: 1.2,
                  ),
                ),
              ),
            ),
          ),
        ),
        if (actionLabel != null) ...[
          const SizedBox(width: 12),
          FilledButton.icon(
            onPressed: onAction,
            icon: const Icon(Icons.add, size: 18),
            label: Text(actionLabel!),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF1A5BFF),
              foregroundColor: Colors.white,
              padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              textStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _AvatarButton extends StatelessWidget {
  const _AvatarButton({required this.initials});
  final String initials;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFF1A5BFF),
      ),
      child: Center(
        child: Text(
          initials,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}