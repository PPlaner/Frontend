import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_sizes.dart' as sizes;
import 'package:frontend/core/theme/theme_extensions.dart';

class WideFilledButton extends StatelessWidget {
  const WideFilledButton({
    required this.onPressed,
    required this.child,
    super.key,
  });

  final VoidCallback? onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        minimumSize: sizes.wideButtonLarge,
        foregroundColor: context.colorScheme.surface,
      ),
      child: child,
    );
  }
}
