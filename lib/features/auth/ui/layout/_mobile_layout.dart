import 'package:flutter/material.dart';
import 'package:kliensy/features/auth/ui/widgets/_auth_logo.dart';

class MobileAuthLayout extends StatelessWidget {
  const MobileAuthLayout({super.key, required this.modal});

  final Widget modal;

  static const double _kModalMaxWidth = 420;
  static const EdgeInsets _kPadding = EdgeInsets.symmetric(
    horizontal: 0,
    vertical: 24,
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: _kPadding,
      child: Column(
        children: [
          AuthLogo(),
          SizedBox(height: 24),
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: _kModalMaxWidth),
              child: modal,
            ),
          ),
        ],
      ),
    );
  }
}
