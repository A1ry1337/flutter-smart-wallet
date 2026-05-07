import 'package:flutter/material.dart';

const double _kMobileBreakpoint = 1040;

class AuthModalCard extends StatelessWidget {
  const AuthModalCard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < _kMobileBreakpoint;

    if (isMobile) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: child,
      );
    }

    return Card(
      elevation: 18,
      shadowColor: Colors.black.withOpacity(0.18),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFFE0E0E0)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: child,
      ),
    );
  }
}

class AuthLink extends StatelessWidget {
  const AuthLink({
    required this.text,
    required this.onTap,
    this.disabled = false,
  });

  final String text;
  final VoidCallback onTap;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: disabled ? MouseCursor.defer : SystemMouseCursors.click,
      child: InkWell(
        onTap: disabled ? null : onTap,
        hoverColor: Colors.transparent,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: disabled ? Colors.grey : const Color(0xFF0A3CC0),
          ),
        ),
      ),
    );
  }
}