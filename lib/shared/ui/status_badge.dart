import 'package:flutter/material.dart';
import 'package:kliensy/features/requests/models/request_model.dart';


class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.status});

  final RequestStatus status;

  @override
  Widget build(BuildContext context) {
    final (color, bg) = switch (status) {
      RequestStatus.newRequest => (
      const Color(0xFF1A5BFF),
      const Color(0xFFE8EEFF)
      ),
      RequestStatus.inProgress => (
      const Color(0xFFE07D00),
      const Color(0xFFFFF3E0)
      ),
      RequestStatus.done => (
      const Color(0xFF1A9E5E),
      const Color(0xFFE6F7F0)
      ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}