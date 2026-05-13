import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/constants/app_sizes.dart' as sizes;
import 'package:frontend/core/theme/theme_extensions.dart';
import 'package:frontend/core/ui/widgets/flow_scaffold.dart';
import 'package:frontend/core/ui/widgets/wide_filled_button.dart';
import 'package:frontend/core/utils/app_assets.dart';
import 'package:frontend/features/vault/presentation/navigation/vault_setup_routes.dart';
import 'package:frontend/features/vault/presentation/notifiers/vault_setup_notifier.dart';
import 'package:frontend/features/vault/presentation/widgets/pin_pad_view.dart';
import 'package:frontend/i18n/strings.g.dart';

class SetupPinScreen extends ConsumerStatefulWidget {
  const SetupPinScreen({super.key});

  @override
  ConsumerState<SetupPinScreen> createState() => _SetupPinScreenState();
}

class _SetupPinScreenState extends ConsumerState<SetupPinScreen> {
  String _pin = '';

  void _onSubmit() {
    ref.read(vaultSetupProvider.notifier).setupPin(_pin);
    unawaited(const SetupRecoveryRoute().push<void>(context));
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, _) =>
          didPop ? ref.read(vaultSetupProvider.notifier).abortFlow() : null,
      child: FlowScaffold(
        body: Column(
          children: [
            Text(
              context.t.setup.pin_create,
              style: context.textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: sizes.betweenTitleAndSub),

            Text(
              t.setup.pin_desc_setup,
              style: context.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 20),

            Image.asset(
              AppAssets.logo,
              height: sizes.smallImageHeight,
              width: sizes.smallImageWidth,
              fit: BoxFit.contain,
            ),

            const Spacer(),

            PinPadView(
              pin: _pin,
              onPinChanged: (pin) => setState(() => _pin = pin),
            ),

            const Spacer(),

            WideFilledButton(
              onPressed: _pin.length == 4 ? _onSubmit : null,
              child: Text(context.t.common.register),
            ),
          ],
        ),
      ),
    );
  }
}
