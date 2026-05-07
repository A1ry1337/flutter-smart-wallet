import 'package:flutter/material.dart';

class AuthBadge extends StatelessWidget {
  const AuthBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF1FF),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Text(
        'ДЛЯ МАЛОГО БИЗНЕСА',
        style: TextStyle(
          fontSize: 16,
          height: 1,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.7,
          color: Color(0xFF155DFF),
        ),
      ),
    );
  }
}
