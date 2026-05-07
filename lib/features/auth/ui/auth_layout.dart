import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AuthLayout extends StatelessWidget {
  const AuthLayout({
    super.key,
    required this.modal,
  });

  final Widget modal;

  static const String _backgroundImage = 'assets/images/auth/auth_background.jpg';
  static const String _rightImage = 'assets/images/auth/auth_right.svg';
  static const String _rightImage2 = 'assets/images/auth/auth_right1.svg'; //todo менять фото логин/регистрация

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = width < 1040;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: Container(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(AuthLayout._backgroundImage),
                    fit: BoxFit.none,
                    alignment: Alignment.center,
                  ),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 20 : 48,
                  vertical: 24,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight - 48,
                      maxWidth: 1824,
                    ),
                    child: isMobile
                        ? _MobileAuthLayout(modal: modal)
                        : _DesktopAuthLayout(modal: modal),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _DesktopAuthLayout extends StatelessWidget {
  const _DesktopAuthLayout({
    required this.modal,
  });

  final Widget modal;

  static const double _leftMaxWidth = 520;
  static const double _modalWidth = 470;
  static const double _imageWidth = 520;

  static const double _leftToModalGap = 160;
  static const double _modalToImageMaxGap = 200;

  static const double _hideRightImageBreakpoint = 1600;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;
        final hideRightImage = availableWidth < _hideRightImageBreakpoint;

        if (hideRightImage) {
          final availableWidth = constraints.maxWidth;

          final gap = (availableWidth - _leftMaxWidth - _modalWidth).clamp(
            32.0,
            _leftToModalGap,
          );

          final leftWidth = availableWidth - gap - _modalWidth;

          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: leftWidth.clamp(300.0, _leftMaxWidth),
                child: const Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.only(top: 50),
                    child: _AuthTextBlock(),
                  ),
                ),
              ),

              SizedBox(width: gap),

              SizedBox(
                width: _modalWidth,
                child: Align(
                  alignment: Alignment.center,
                  child: modal,
                ),
              ),
            ],
          );
        }

        // Сколько места осталось, если левая часть стоит в полном размере.
        final freeSpaceAfterFullLayout =
            availableWidth -
                _leftMaxWidth -
                _leftToModalGap -
                _modalWidth -
                _imageWidth;

        // Этот gap сначала 200, потом уменьшается до 0.
        final modalToImageGap = freeSpaceAfterFullLayout.clamp(
          0.0,
          _modalToImageMaxGap,
        );

        // Левая часть начинает уменьшаться только после того,
        // как gap между модалкой и картинкой стал 0.
        final leftWidth =
            availableWidth -
                _leftToModalGap -
                _modalWidth -
                modalToImageGap -
                _imageWidth;

        final safeLeftWidth = leftWidth.clamp(0.0, _leftMaxWidth);

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                width: safeLeftWidth,
                child: const Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.only(top: 50),
                    child: _AuthTextBlock(),
                  ),
                ),
              ),

              const SizedBox(width: _leftToModalGap),

              SizedBox(
                width: _modalWidth,
                child: Align(
                  alignment: Alignment.center,
                  child: modal,
                ),
              ),

              SizedBox(width: modalToImageGap),

              const SizedBox(
                width: _imageWidth,
                child: Align(
                  alignment: Alignment.center,
                  child: _AuthImageBlock(),
                ),
              ),
            ],
          ),
        );
      },
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
      child: Image.asset(
        AuthLayout._backgroundImage,
        fit: BoxFit.none,
        alignment: Alignment.center,
      ),
    );
  }
}

class _AuthTextBlock extends StatelessWidget {
  const _AuthTextBlock();

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 520),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _AuthLogo(),

          const SizedBox(height: 48),

          const _AuthBadge(),

          const SizedBox(height: 48),

          Text(
            'Все заявки и клиенты\nв одном месте',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              fontSize: 40,
              height: 1.12,
              fontWeight: FontWeight.w800,
              letterSpacing: -1.2,
              color: Colors.black,
            ),
          ),

          const SizedBox(height: 22),

          Text(
            'Удобная система для мастеров и небольших команд.\n'
                'Больше никаких потерянных заявок и клиентов\n'
                'в мессенджерах и таблицах.',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontSize: 16,
              height: 1.32,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF333333),
            ),
          ),

          const SizedBox(height: 48),

          const _FeatureItem(
            icon: Icons.check_rounded,
            title: 'Заявки под контролем',
            subtitle: 'Статусы, комментарии, история',
          ),

          const SizedBox(height: 34),

          const _FeatureItem(
            icon: Icons.campaign_outlined,
            title: 'Клиенты и история',
            subtitle: 'Вся информация о клиентах и их заявках',
          ),

          const SizedBox(height: 34),

          const _FeatureItem(
            icon: Icons.notifications_none_rounded,
            title: 'Уведомления',
            subtitle: 'Не пропустите ни одной новой заявки',
          ),
        ],
      ),
    );
  }
}

class _AuthLogo extends StatelessWidget {
  const _AuthLogo();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
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
        ),
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

class _AuthBadge extends StatelessWidget {
  const _AuthBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 10,
      ),
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

class _FeatureItem extends StatelessWidget {
  const _FeatureItem({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: const Color(0xFFEAF1FF),
            borderRadius: BorderRadius.circular(11),
          ),
          alignment: Alignment.center,
          child: Icon(
            icon,
            size: 40,
            color: const Color(0xFF155DFF),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontSize: 16,
                  height: 1.2,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF222222),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontSize: 16,
                  height: 1.25,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF444444),
                ),
              ),
            ],
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
    return ClipRRect(
      borderRadius: BorderRadius.circular(36),
      child: SizedBox(
        height: isMobile ? 220 : 520,
        width: double.infinity,
        child: SvgPicture.asset(
          AuthLayout._rightImage,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}