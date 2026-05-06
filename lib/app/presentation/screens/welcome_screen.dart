import 'dart:async';

import 'package:flutter/material.dart';
import 'package:frontend/core/theme/theme_extensions.dart';
import 'package:frontend/core/ui/widgets/wide_filled_button.dart';
import 'package:frontend/core/utils/app_assets.dart';
import 'package:frontend/features/auth/presentation/navigation/auth_routes.dart';
import 'package:frontend/features/vault/presentation/navigation/vault_setup_routes.dart';
import 'package:frontend/i18n/strings.g.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorScheme.surfaceContainer,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const Spacer(flex: 3),

              Text(
                context.t.common.app_name,
                style: context.textTheme.displayLarge,
              ),

              const SizedBox(height: 24),

              Image.asset(
                AppAssets.logo,
                height: 159,
                width: 168,
                fit: BoxFit.contain,
              ),

              const Spacer(flex: 2),

              Text(
                context.t.auth.tagline,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 8),

              Text(
                context.t.auth.chooseMethod,
                textAlign: TextAlign.center,
              ),

              const Spacer(flex: 3),

              // ── Створити локальне сховище ──
              WideFilledButton(
                onPressed: () {
                  if (context.mounted) {
                    unawaited(const SetupVaultRoute().push<void>(context));
                  }
                },
                child: Text(
                  context.t.auth.createLocalStorage,
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
                ),
                child: Text(
                  context.t.auth.haveAccount,
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
