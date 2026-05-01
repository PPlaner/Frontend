import 'dart:async';

import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/core/utils/app_assets.dart';
import 'package:frontend/features/vault/presentation/navigation/vault_setup_routes.dart';
import 'package:frontend/i18n/strings.g.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = AppColors.of(context);

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
                t.auth.welcome_title,
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium,
              ),

              const SizedBox(height: 8),

              Text(
                t.auth.welcome_subtitle,
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium,
              ),

              const Spacer(flex: 3),

              // ── Створити локальне сховище ──
              FilledButton(
                onPressed: () async {
                  if (context.mounted) {
                    unawaited(const SetupVaultRoute().push<void>(context));
                  }
                },
                style: FilledButton.styleFrom(
                  minimumSize: const Size(double.infinity, 51),
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  t.auth.create_local,
                  style: textTheme.labelLarge?.copyWith(color: Colors.white),
                ),
              ),

              const SizedBox(height: 16),

              // ── Вже є акаунт ──
              OutlinedButton(
                onPressed: () {
                  // TO-DO: навігація до екрану логіну
                },
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 51),
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary),
                  backgroundColor: colors.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  t.auth.already_have_account,
                  style: textTheme.labelLarge?.copyWith(
                    color: AppColors.primary,
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
