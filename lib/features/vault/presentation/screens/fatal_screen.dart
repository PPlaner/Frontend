import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_sizes.dart' as sizes;
import 'package:frontend/core/theme/theme_extensions.dart';
import 'package:frontend/core/ui/widgets/flow_scaffold.dart';
import 'package:frontend/core/utils/app_assets.dart';
import 'package:frontend/i18n/strings.g.dart';

class FatalScreen extends StatefulWidget {
  const FatalScreen({super.key});

  @override
  State<FatalScreen> createState() => _FatalScreenState();
}

class _FatalScreenState extends State<FatalScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 0.6, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 0.6, curve: Curves.easeOutBack),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FlowScaffold(
      showAppBar: false,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  AppAssets.logo,
                  height: 120,
                  width: 120,
                  fit: BoxFit.contain,
                ),

                const SizedBox(height: 24),

                Text(
                  context.t.vault.fatal.title,
                  style: context.textTheme.displayLarge,
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: sizes.betweenTitleAndSub),

                Text(
                  context.t.vault.fatal.subtitle,
                  style: context.textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 48),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
