import 'package:flutter/material.dart';
import 'package:frontend/core/presentation/theme/theme_extensions.dart';
import 'package:frontend/core/presentation/widgets/back_app_bar.dart';
import 'package:frontend/core/presentation/widgets/safe_screen_wrapper.dart';

class FlowScaffold extends StatelessWidget {
  const FlowScaffold({
    required this.body,
    this.showAppBar = true,
    this.padding = const EdgeInsets.fromLTRB(24, 20, 24, 24),
    super.key,
  });

  final Widget body;
  final bool showAppBar;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorScheme.surfaceContainer,
      appBar: showAppBar ? const BackAppBar() : null,
      body: SafeScreenWrapper(
        padding: padding,
        child: body,
      ),
    );
  }
}
