import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kliensy/core/router/app_routes.dart';
import 'package:kliensy/features/auth/state/auth_controller.dart';



const double _kDesktopBreakpoint = 768;

/// Тип текущей вкладки для подсветки навигации.
enum AppTab { requests, clients, settings }

extension AppTabRoute on AppTab {
  String get route => switch (this) {
    AppTab.requests => AppRoutes.requests,
    AppTab.clients => AppRoutes.clients,
    AppTab.settings => AppRoutes.settings,
  };

  String get label => switch (this) {
    AppTab.requests => 'Заявки',
    AppTab.clients => 'Клиенты',
    AppTab.settings => 'Настройки',
  };

  IconData get icon => switch (this) {
    AppTab.requests => Icons.receipt_long_rounded,
    AppTab.clients => Icons.people_alt_rounded,
    AppTab.settings => Icons.settings_rounded,
  };
}

/// Главный «shell» — оборачивает все страницы авторизованной зоны.
/// Навигация: слева (≥768) / снизу (<768).
class AppShell extends StatelessWidget {
  const AppShell({
    super.key,
    required this.child,
    required this.activeTab,
    required this.authController,
  });

  final Widget child;
  final AppTab activeTab;
  final AuthController authController;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isDesktop = width >= _kDesktopBreakpoint;

    if (isDesktop) {
      return _DesktopShell(
        activeTab: activeTab,
        authController: authController,
        child: child,
      );
    }

    return _MobileShell(
      activeTab: activeTab,
      authController: authController,
      child: child,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Desktop layout
// ─────────────────────────────────────────────────────────────────────────────

class _DesktopShell extends StatelessWidget {
  const _DesktopShell({
    required this.child,
    required this.activeTab,
    required this.authController,
  });

  final Widget child;
  final AppTab activeTab;
  final AuthController authController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FB),
      body: Row(
        children: [
          _DesktopSidebar(
            activeTab: activeTab,
            authController: authController,
          ),
          Expanded(child: child),
        ],
      ),
    );
  }
}

class _DesktopSidebar extends StatelessWidget {
  const _DesktopSidebar({
    required this.activeTab,
    required this.authController,
  });

  final AppTab activeTab;
  final AuthController authController;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      color: const Color(0xFF1A1D2E),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          // Logo
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _SidebarLogo(),
          ),
          const SizedBox(height: 32),
          // Nav items
          for (final tab in AppTab.values)
            _SidebarNavItem(
              tab: tab,
              isActive: activeTab == tab,
            ),
          const Spacer(),
          const Divider(color: Color(0xFF2D3148), height: 1),
          const SizedBox(height: 8),
          // Logout
          _SidebarLogoutButton(authController: authController),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _SidebarLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: const Color(0xFF1A5BFF),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Center(
            child: Text(
              'K',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 18,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        const Text(
          'Kliensy',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _SidebarNavItem extends StatelessWidget {
  const _SidebarNavItem({required this.tab, required this.isActive});

  final AppTab tab;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: Material(
        color: isActive
            ? const Color(0xFF1A5BFF).withOpacity(0.18)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () => context.go(tab.route),
          child: Container(
            height: 44,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Icon(
                  tab.icon,
                  size: 20,
                  color: isActive
                      ? const Color(0xFF1A5BFF)
                      : const Color(0xFF8B90A7),
                ),
                const SizedBox(width: 12),
                Text(
                  tab.label,
                  style: TextStyle(
                    color: isActive ? Colors.white : const Color(0xFF8B90A7),
                    fontSize: 15,
                    fontWeight:
                    isActive ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SidebarLogoutButton extends StatelessWidget {
  const _SidebarLogoutButton({required this.authController});

  final AuthController authController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () => authController.logout(),
          child: Container(
            height: 44,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: const Row(
              children: [
                Icon(Icons.logout_rounded,
                    size: 20, color: Color(0xFF8B90A7)),
                SizedBox(width: 12),
                Text(
                  'Выйти',
                  style: TextStyle(
                    color: Color(0xFF8B90A7),
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Mobile layout
// ─────────────────────────────────────────────────────────────────────────────

class _MobileShell extends StatelessWidget {
  const _MobileShell({
    required this.child,
    required this.activeTab,
    required this.authController,
  });

  final Widget child;
  final AppTab activeTab;
  final AuthController authController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: child,
      bottomNavigationBar: _MobileBottomNav(activeTab: activeTab),
    );
  }
}

class _MobileBottomNav extends StatelessWidget {
  const _MobileBottomNav({required this.activeTab});

  final AppTab activeTab;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            children: AppTab.values
                .map((tab) => _MobileNavItem(
              tab: tab,
              isActive: activeTab == tab,
            ))
                .toList(),
          ),
        ),
      ),
    );
  }
}

class _MobileNavItem extends StatelessWidget {
  const _MobileNavItem({required this.tab, required this.isActive});

  final AppTab tab;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () => context.go(tab.route),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              tab.icon,
              size: 24,
              color: isActive
                  ? const Color(0xFF1A5BFF)
                  : const Color(0xFFADB5BD),
            ),
            const SizedBox(height: 4),
            Text(
              tab.label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                color: isActive
                    ? const Color(0xFF1A5BFF)
                    : const Color(0xFFADB5BD),
              ),
            ),
          ],
        ),
      ),
    );
  }
}