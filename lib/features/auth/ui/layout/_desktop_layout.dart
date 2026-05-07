import 'package:flutter/material.dart';

import 'package:kliensy/features/auth/ui/auth_page.dart';
import '_auth_image_block.dart';
import '_auth_text_block.dart';

const String _kBackgroundImage = 'assets/images/auth/auth_background.jpg';

const double _kLeftMaxWidth = 520;
const double _kModalWidth = 470;
const double _kImageWidth = 520;
const double _kLeftToModalGap = 160;
const double _kModalToImageMaxGap = 200;
const double _kMaxContentWidth = 1824;

const double _kHideImageBreakpoint = 1600;

class DesktopAuthLayout extends StatelessWidget {
  const DesktopAuthLayout({
    super.key,
    required this.modal,
    required this.mode,
  });

  final Widget modal;
  final AuthMode mode;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(_kBackgroundImage),
          fit: BoxFit.none,
          alignment: Alignment.center,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: _kMaxContentWidth),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final available = constraints.maxWidth;
            final hideImage = available < _kHideImageBreakpoint;

            return IntrinsicHeight(
              child: hideImage
                  ? _RowWithoutImage(available: available, modal: modal)
                  : _RowWithImage(available: available, modal: modal, mode: mode),
            );
          },
        ),
      ),
    );
  }
}

class _RowWithoutImage extends StatelessWidget {
  const _RowWithoutImage({required this.available, required this.modal});

  final double available;
  final Widget modal;

  @override
  Widget build(BuildContext context) {
    final gap = (available - _kLeftMaxWidth - _kModalWidth)
        .clamp(32.0, _kLeftToModalGap);

    final leftWidth =
    (available - gap - _kModalWidth).clamp(300.0, _kLeftMaxWidth);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _LeftBlock(width: leftWidth),
        SizedBox(width: gap),
        _ModalBlock(modal: modal),
      ],
    );
  }
}

class _RowWithImage extends StatelessWidget {
  const _RowWithImage({
    required this.available,
    required this.modal,
    required this.mode,
  });

  final double available;
  final Widget modal;
  final AuthMode mode;

  @override
  Widget build(BuildContext context) {
    final freeSpace =
        available - _kLeftMaxWidth - _kLeftToModalGap - _kModalWidth - _kImageWidth;
    final modalToImageGap = freeSpace.clamp(0.0, _kModalToImageMaxGap);
    final leftWidth =
        (available - _kLeftToModalGap - _kModalWidth - modalToImageGap - _kImageWidth)
            .clamp(0.0, _kLeftMaxWidth);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _LeftBlock(width: leftWidth),
        const SizedBox(width: _kLeftToModalGap),
        _ModalBlock(modal: modal),
        SizedBox(width: modalToImageGap),
        SizedBox(
          width: _kImageWidth,
          child: Align(
            alignment: Alignment.center,
            child: AuthImageBlock(mode: mode),
          ),
        ),
      ],
    );
  }
}

class _LeftBlock extends StatelessWidget {
  const _LeftBlock({required this.width});

  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: const Align(
        alignment: Alignment.topLeft,
        child: Padding(
          padding: EdgeInsets.only(top: 30),
          child: AuthTextBlock(),
        ),
      ),
    );
  }
}

class _ModalBlock extends StatelessWidget {
  const _ModalBlock({required this.modal});

  final Widget modal;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _kModalWidth,
      child: Align(
        alignment: Alignment.center,
        child: modal,
      ),
    );
  }
}
