import 'package:flutter/material.dart';
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
              child: SizedBox(
                width: 168,
                height: 159,
                child: Image.asset(
                  AppAssets.logo,
                  height: 159,
                  width: 168,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
