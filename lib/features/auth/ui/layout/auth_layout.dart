import 'package:flutter/material.dart';

import 'package:kliensy/features/auth/ui/auth_page.dart';
import '_desktop_layout.dart';
import '_mobile_layout.dart';

const double _kMobileBreakpoint = 1040;

class AuthLayout extends StatelessWidget {
  const AuthLayout({
    super.key,
    required this.modal,
    required this.mode,
  });

  final Widget modal;
  final AuthMode mode;

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < _kMobileBreakpoint;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: isMobile
                    ? MobileAuthLayout(modal: modal)
                    : DesktopAuthLayout(modal: modal, mode: mode),
              ),
            );
          },
        ),
      ),
    );
  }
}
