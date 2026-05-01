import 'dart:math';

import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/core/ui/widgets/back_app_bar.dart';
import 'package:frontend/core/utils/app_assets.dart';
import 'package:frontend/i18n/strings.g.dart';
import 'package:pattern_lock/pattern_lock.dart';

class PatternLockScreen extends StatefulWidget {
  final bool isSetup;

  const PatternLockScreen({super.key, this.isSetup = false});

  @override
  State<PatternLockScreen> createState() => _PatternLockScreenState();
}

class _PatternLockScreenState extends State<PatternLockScreen>
    with SingleTickerProviderStateMixin {
  List<int>? pattern;
  bool isError = false;

  late AnimationController _shakeController;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  Future<void> _triggerError() async {
    setState(() => isError = true);
    await _shakeController.forward(from: 0);
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          isError = false;
          pattern = null;
        });
      }
    });
  }

  void _onSubmit() {
    if (widget.isSetup) {
      Navigator.pushNamed(context, '/secret-setup');
    } else {
      // TODO: перевірити паттерн і увійти
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = AppColors.of(context);

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: const BackAppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Text(
                widget.isSetup ? t.setup.pattern_create : t.setup.pattern_enter,
                style: textTheme.displayLarge?.copyWith(fontSize: 28),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                isError
                    ? t.setup.pattern_short
                    : widget.isSetup
                    ? t.setup.pattern_desc_setup
                    : t.setup.pattern_desc_login,
                style: textTheme.bodyMedium?.copyWith(
                  color: isError ? AppColors.error : null, // статичний error
                  fontWeight: isError ? FontWeight.bold : null,
                ),
                textAlign: TextAlign.center,
              ),
              const Spacer(flex: 3),
              AnimatedBuilder(
                animation: _shakeController,
                builder: (context, child) {
                  final offset = sin(_shakeController.value * pi * 4) * 10;
                  return Transform.translate(
                    offset: Offset(isError ? offset : 0, 0),
                    child: child,
                  );
                },
                child: SizedBox(
                  height: 300,
                  child: PatternLock(
                    selectedColor: isError
                        ? AppColors
                              .error // статичний
                        : AppColors.primary, // статичний
                    notSelectedColor: colors.textSecondary.withOpacity(0.3),
                    onInputComplete: (input) async {
                      if (input.length < 4) {
                        await _triggerError();
                      } else {
                        setState(() {
                          isError = false;
                          pattern = input;
                        });
                      }
                    },
                  ),
                ),
              ),
              const Spacer(),
              Image.asset(
                AppAssets.logo,
                height: 160,
                width: 160,
                fit: BoxFit.contain,
              ),
              const Spacer(flex: 3),
              FilledButton(
                onPressed: (pattern != null && pattern!.length >= 4 && !isError)
                    ? _onSubmit
                    : null,
                style: FilledButton.styleFrom(
                  minimumSize: const Size(double.infinity, 56),
                  backgroundColor: AppColors.primary, // статичний
                ),
                child: Text(
                  widget.isSetup ? t.common.register : t.common.login,
                  style: textTheme.labelLarge?.copyWith(color: Colors.white),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

