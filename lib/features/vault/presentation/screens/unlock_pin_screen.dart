import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/presentation/app_assets.dart';
import 'package:frontend/core/presentation/app_sizes.dart' as sizes;
import 'package:frontend/core/presentation/theme/theme_extensions.dart';
import 'package:frontend/core/presentation/widgets/flow_scaffold.dart';
import 'package:frontend/core/presentation/widgets/wide_filled_button.dart';
import 'package:frontend/features/vault/presentation/notifiers/vault_unlock_notifier.dart';
import 'package:frontend/features/vault/presentation/widgets/pin_pad_view.dart';
import 'package:frontend/i18n/strings.g.dart';

class UnlockPinScreen extends ConsumerStatefulWidget {
  const UnlockPinScreen({super.key});

  @override
  ConsumerState<UnlockPinScreen> createState() => _UnlockPinScreenState();
}

class _UnlockPinScreenState extends ConsumerState<UnlockPinScreen> {
  String _pin = '';

  void _onSubmit() =>
      ref.read(vaultUnlockProvider.notifier).unlockWithPin(_pin);

  @override
  Widget build(BuildContext context) {
    return FlowScaffold(
      body: Column(
        children: [
          Text(
            context.t.setup.pin_enter,
            style: context.textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: sizes.betweenTitleAndSub),

          Text(
            t.setup.pin_desc_login,
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
            child: Text(context.t.common.login),
          ),
        ],
      ),
    );
  }
}
