import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:kliensy/features/auth/ui/auth_page.dart';

const String _kLoginImage = 'assets/images/auth/auth_right_login.svg';
const String _kRegisterImage = 'assets/images/auth/auth_right_register.svg';

class AuthImageBlock extends StatelessWidget {
  const AuthImageBlock({
    super.key,
    required this.mode,
    this.height = 520,
  });

  final AuthMode mode;

  final double height;

  String get _asset =>
      mode == AuthMode.login ? _kLoginImage : _kRegisterImage;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(36),
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: SvgPicture.asset(
          _asset,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
