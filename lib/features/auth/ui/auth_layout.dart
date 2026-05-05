import 'package:flutter/material.dart';

class AuthLayout extends StatelessWidget {
  const AuthLayout({
    super.key,
    required this.modal,
  });

  final Widget modal;

  static const String _imageUrl =
      'https://images.unsplash.com/photo-1639322537228-f710d846310a';

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = width < 850;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          const _AuthBackground(),

          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 20 : 48,
                  vertical: 24,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(),
                  child: isMobile
                      ? _MobileAuthLayout(modal: modal)
                      : _DesktopAuthLayout(modal: modal),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DesktopAuthLayout extends StatelessWidget {
  const _DesktopAuthLayout({
    required this.modal,
  });

  final Widget modal;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 640,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Expanded(
            flex: 3,
            child: _AuthTextBlock(),
          ),

          const SizedBox(width: 40),

          SizedBox(
            width: 470,
            child: modal,
          ),

          const SizedBox(width: 40),

          const Expanded(
            flex: 3,
            child: _AuthImageBlock(),
          ),
        ],
      ),
    );
  }
}

class _MobileAuthLayout extends StatelessWidget {
  const _MobileAuthLayout({
    required this.modal,
  });

  final Widget modal;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _AuthTextBlock(),
        const SizedBox(height: 28),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: modal,
        ),
        const SizedBox(height: 28),
        const _AuthImageBlock(isMobile: true),
      ],
    );
  }
}

class _AuthBackground extends StatelessWidget {
  const _AuthBackground();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Opacity(
        opacity: 0.045,
        child: Image.network(
          AuthLayout._imageUrl,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class _AuthTextBlock extends StatelessWidget {
  const _AuthTextBlock();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 360),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Все заявки и клиенты в одном месте',
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 40,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'Удобная система для мастеров и небольших команд. Больше никаких потерянных заявок и клиентовв мессенджерах и таблицах.',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 28),
            const _FeatureItem(text: 'Заявки под контролем'),
            SizedBox(height: 10),
            const _FeatureItem(text: 'Клиенты и история'),
            SizedBox(height: 10),
            const _FeatureItem(text: 'Уведомления'),
          ],
        ),
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  const _FeatureItem({
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: const BoxDecoration(
            color: Color(0xFF6750A4),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          text,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}

class _AuthImageBlock extends StatelessWidget {
  const _AuthImageBlock({
    this.isMobile = false,
  });

  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(36),
        child: SizedBox(
          height: isMobile ? 220 : 520,
          width: double.infinity,
          child: Image.network(
            AuthLayout._imageUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}