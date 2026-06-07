import 'package:flutter/material.dart';

enum SnackBarType { success, error, info, warning }

void showSnackBar(
  BuildContext context,
  String message, {
  SnackBarType type = SnackBarType.info,
  Duration duration = const Duration(seconds: 3),
}) {
  final Color backgroundColor;
  final IconData icon;

  switch (type) {
    case SnackBarType.success:
      backgroundColor = const Color(0xFF4CAF50);
      icon = Icons.check_circle;
      break;
    case SnackBarType.error:
      backgroundColor = const Color(0xFFEF5350);
      icon = Icons.error;
      break;
    case SnackBarType.warning:
      backgroundColor = const Color(0xFFFF9800);
      icon = Icons.warning;
      break;
    case SnackBarType.info:
      backgroundColor = const Color(0xFF2196F3);
      icon = Icons.info;
      break;
  }

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      backgroundColor: backgroundColor,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      duration: duration,
      margin: const EdgeInsets.all(16),
    ),
  );
}
