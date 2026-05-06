import 'package:flutter/material.dart';

class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hintText,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
  });

  final TextEditingController controller;
  final String label;
  final String? hintText;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    final bool isPassword = widget.obscureText;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),

        const SizedBox(height: 4),

        TextFormField(
          controller: widget.controller,
          obscureText: isPassword ? _obscureText : false,
          keyboardType: widget.keyboardType,
          validator: widget.validator,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: const TextStyle(
              fontSize: 16,
              color: Color(0xFFB8B8B8),
            ),

            constraints: const BoxConstraints(
              minHeight: 40,
            ),

            contentPadding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 10,
            ),

            suffixIcon: isPassword
                ? IconButton(
              style: IconButton.styleFrom(
                hoverColor: Colors.transparent,
                splashFactory: NoSplash.splashFactory,
                highlightColor: Colors.transparent,
              ),
              icon: Icon(
                _obscureText
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                size: 22,
                color: const Color(0xFF777777),
              ),
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
            )
                : null,

            suffixIconConstraints: const BoxConstraints(
              minWidth: 36,
              minHeight: 40,
            ),

            filled: true,
            fillColor: Colors.white,

            errorStyle: const TextStyle(
              fontSize: 12,
              height: 1.1,
            ),

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Color(0xFFE2E2E2),
                width: 1,
              ),
            ),

            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Color(0xFFE2E2E2),
                width: 1,
              ),
            ),

            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Color(0xFF1A5BFF),
                width: 1,
              ),
            ),

            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Colors.red,
                width: 1,
              ),
            ),

            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Colors.red,
                width: 1,
              ),
            ),
          ),
        ),
      ],
    );
  }
}