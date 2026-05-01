import 'dart:async';

import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/core/utils/app_assets.dart';
import 'package:frontend/features/auth/presentation/navigation/auth_routes.dart';
import 'package:frontend/features/vault/presentation/navigation/vault_setup_routes.dart';
import 'package:frontend/i18n/strings.g.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

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
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const Spacer(flex: 3),

              Text(t.common.app_name, style: textTheme.displayLarge),

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
                  if (context.mounted) {
                    unawaited(const SetupVaultRoute().push<void>(context));
                  }
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

              // ── Вже є акаунт ──
              OutlinedButton(
                onPressed: () {
                  if (context.mounted) {
                    unawaited(const LoginRoute().push<void>(context));
                  }
                },
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 51),
                  foregroundColor: colorScheme.primary,
                  side: BorderSide(color: colorScheme.primary),
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
