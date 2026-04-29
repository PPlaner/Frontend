import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/core/utils/app_assets.dart';
import 'package:frontend/i18n/strings.g.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final colors = AppColors.of(context);
    final t = context.t;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(flex: 3),
              Text(t.appName, style: textTheme.displayLarge),
              const SizedBox(height: 24),
              Image.asset(
                AppAssets.logo,
                height: 159,
                width: 168,
                fit: BoxFit.contain,
              ),
              const Spacer(flex: 2),
              Text(
                t.auth.tagline,
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
              Text(
                t.auth.chooseMethod,
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium,
              ),
              const Spacer(flex: 3),

              // ── Створити локальне сховище ──
              FilledButton(
                onPressed: () {
                  // TODO: навігація до вибору методу шифрування
                },
                style: FilledButton.styleFrom(
                  minimumSize: const Size(double.infinity, 51),
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colors.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  t.auth.createLocalStorage,
                  style: textTheme.labelLarge?.copyWith(color: colors.surface),
                ),
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () {
                  // TODO: навігація до екрану логіну
                },
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 51),
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary, width: 1),
                  backgroundColor: colors.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  t.auth.haveAccount,
                  style: textTheme.labelLarge?.copyWith(
                    color: colorScheme.primary,
                  ),
                ),
              ),
              const Spacer(flex: 10),
            ],
          ),
        ),
      ),
    );
  }
}