import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_sizes.dart' as sizes;
import 'package:frontend/core/utils/app_assets.dart';

class EmptyStateView extends StatelessWidget {
  const EmptyStateView({required this.title, super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
          child: Text(title, style: textTheme.displayLarge),
        ),
        Expanded(
          child: Center(
            child: Opacity(
              opacity: 0.45,
              child: Image.asset(
                AppAssets.logo,
                height: sizes.largeImageHeight,
                width: sizes.largeImageWidth,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
