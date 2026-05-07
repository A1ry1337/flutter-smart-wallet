import 'package:flutter/material.dart';

class FeatureItem extends StatelessWidget {
  const FeatureItem({
    super.key,
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
        _FeatureIcon(icon: icon),
        const SizedBox(width: 20),
        Expanded(child: _FeatureText(title: title, subtitle: subtitle)),
      ],
    );
  }
}

class _FeatureIcon extends StatelessWidget {
  const _FeatureIcon({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        color: const Color(0xFFEAF1FF),
        borderRadius: BorderRadius.circular(11),
      ),
      alignment: Alignment.center,
      child: Icon(icon, size: 40, color: const Color(0xFF155DFF)),
    );
  }
}

class _FeatureText extends StatelessWidget {
  const _FeatureText({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
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
    );
  }
}
