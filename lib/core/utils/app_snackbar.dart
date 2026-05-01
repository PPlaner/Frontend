import 'package:flutter/material.dart';

extension AppSnackbarExtension on BuildContext {
  void showSnackbarError(String message) {
    final theme = Theme.of(this);

    ScaffoldMessenger.of(this)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: theme.colorScheme.error,
          // behavior: SnackBarBehavior.floating,
          content: Text(
            message,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onError,
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
  }
}
