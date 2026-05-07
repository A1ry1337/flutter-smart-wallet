import 'package:flutter/material.dart';

class AuthLogo extends StatelessWidget {
  const AuthLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _LogoIcon(),
        const SizedBox(width: 4),
        const Text(
          'liensy',
          style: TextStyle(
            fontSize: 34,
            height: 1,
            fontWeight: FontWeight.w400,
            color: Colors.black,
            fontFamily: 'Georgia',
          ),
        ),
      ],
    );
  }
}

class _LogoIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 58,
      height: 58,
      decoration: BoxDecoration(
        color: const Color(0xFF4595F6),
        borderRadius: BorderRadius.circular(11),
      ),
      alignment: Alignment.center,
      child: const Text(
        'k',
        style: TextStyle(
          fontSize: 28,
          height: 1,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          fontFamily: 'Georgia',
        ),
      ),
    );
  }
}
