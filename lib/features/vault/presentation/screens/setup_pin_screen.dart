import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/core/ui/widgets/back_app_bar.dart';
import 'package:frontend/core/utils/app_assets.dart';
import 'package:frontend/features/vault/presentation/navigation/vault_setup_routes.dart';
import 'package:frontend/features/vault/presentation/notifiers/vault_setup_notifier.dart';
import 'package:frontend/features/vault/presentation/widgets/pin_pad_view.dart';
import 'package:frontend/features/vault/presentation/widgets/safe_padding.dart';
import 'package:frontend/i18n/strings.g.dart';

class SetupPinScreen extends ConsumerWidget {
  const SetupPinScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final colors = AppColors.of(context);

    return PopScope(
      onPopInvokedWithResult: (didPop, _) =>
          didPop ? ref.invalidate(vaultSetupProvider) : null,
      child: Scaffold(
        backgroundColor: colors.surface,
        appBar: const BackAppBar(),
        body: SafePadding(
          child: Column(
            children: [
              const SizedBox(height: 10),

              Text(
                context.t.setup.pin_create,
                style: textTheme.displayLarge?.copyWith(fontSize: 26),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 4),

              Text(
                t.setup.pin_desc_setup,
                style: textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 20),

              Image.asset(
                AppAssets.logo,
                height: 100,
                width: 100,
                fit: BoxFit.contain,
              ),

              Expanded(
                child: PinPadView(
                  buttonTitle: context.t.common.register,
                  onPinCompleted: (pin) {
                    ref.read(vaultSetupProvider.notifier).setupPin(pin);
                    unawaited(const SetupRecoveryRoute().push<void>(context));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
