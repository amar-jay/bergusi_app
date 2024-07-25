import 'package:flutter/material.dart';
import 'package:myapp/constants.dart';

enum SnackBarType { error, warning, notification, success }

void showCustomSnackBar(
    BuildContext context, String message, SnackBarType type) {
  final theme = Theme.of(context);
  Color borderColor = theme.primaryColor;
  String actionLabel = 'OK'; // Default action label
  // Customize appearance based on type
  switch (type) {
    case SnackBarType.error:
      borderColor = errorColor;
      actionLabel = 'Close';
      break;
    case SnackBarType.warning:
      borderColor = warningColor;
      actionLabel = 'Dismiss';
      break;
    case SnackBarType.notification:
      borderColor = purpleColor;
      actionLabel = 'OK';
      break;
    case SnackBarType.success:
      borderColor = successColor;
      actionLabel = 'Close';
      break;
  }

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
        backgroundColor: Colors.white,
        content: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            message,
            style: const TextStyle(color: Colors.black),
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.0),
          side: BorderSide(color: borderColor, width: 2.0),
        ),
        behavior:
            SnackBarBehavior.floating, // To make it float above the bottom bar
        // Extra functionality: Add an action button
        action: SnackBarAction(
          label: actionLabel,
          textColor: theme.colorScheme.onPrimary,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
        onVisible: () {
          Future.delayed(const Duration(seconds: 3));
        }),
  );
}
