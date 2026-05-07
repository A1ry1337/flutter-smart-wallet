import 'package:flutter/material.dart';

import '../widgets/_auth_badge.dart';
import '../widgets/_auth_logo.dart';
import '../widgets/_feature_item.dart';

class AuthTextBlock extends StatelessWidget {
  const AuthTextBlock({super.key});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 520),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AuthLogo(),
          const SizedBox(height: 48),
          const AuthBadge(),
          const SizedBox(height: 48),
          _buildHeadline(context),
          const SizedBox(height: 22),
          _buildSubtitle(context),
          const SizedBox(height: 48),
          for (int i = 0; i < _features.length; i++) ...[
            _FeatureRow(item: _features[i]),
            if (i < _features.length - 1) const SizedBox(height: 34),
          ],
        ],
      ),
    );
  }

  Widget _buildHeadline(BuildContext context) {
    return Text(
      'Все заявки и клиенты\nв одном месте',
      style: Theme.of(context).textTheme.displaySmall?.copyWith(
        fontSize: 40,
        height: 1.12,
        fontWeight: FontWeight.w800,
        letterSpacing: -1.2,
        color: Colors.black,
      ),
    );
  }

  Widget _buildSubtitle(BuildContext context) {
    return Text(
      'Удобная система для мастеров и небольших команд.\n'
      'Больше никаких потерянных заявок и клиентов\n'
      'в мессенджерах и таблицах.',
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        fontSize: 16,
        height: 1.32,
        fontWeight: FontWeight.w400,
        color: const Color(0xFF333333),
      ),
    );
  }
}


class _FeatureData {
  const _FeatureData({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;
}

const List<_FeatureData> _features = [
  _FeatureData(
    icon: Icons.check_rounded,
    title: 'Заявки под контролем',
    subtitle: 'Статусы, комментарии, история',
  ),
  _FeatureData(
    icon: Icons.campaign_outlined,
    title: 'Клиенты и история',
    subtitle: 'Вся информация о клиентах и их заявках',
  ),
  _FeatureData(
    icon: Icons.notifications_none_rounded,
    title: 'Уведомления',
    subtitle: 'Не пропустите ни одной новой заявки',
  ),
];

class _FeatureRow extends StatelessWidget {
  const _FeatureRow({required this.item});

  final _FeatureData item;

  @override
  Widget build(BuildContext context) {
    return FeatureItem(
      icon: item.icon,
      title: item.title,
      subtitle: item.subtitle,
    );
  }
}
