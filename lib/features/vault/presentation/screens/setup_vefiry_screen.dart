import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/presentation/app_assets.dart';
import 'package:frontend/core/presentation/app_sizes.dart' as sizes;
import 'package:frontend/core/presentation/theme/theme_extensions.dart';
import 'package:frontend/core/presentation/widgets/flow_scaffold.dart';
import 'package:frontend/core/presentation/widgets/wide_filled_button.dart';
import 'package:frontend/features/vault/presentation/notifiers/vault_setup_notifier.dart';
import 'package:frontend/features/vault/presentation/widgets/recovery_verify_form.dart';
import 'package:frontend/i18n/strings.g.dart';

class SetupVerifyScreen extends ConsumerStatefulWidget {
  const SetupVerifyScreen({super.key});

  @override
  ConsumerState<SetupVerifyScreen> createState() => _SetupVerifyScreenState();
}

class _SetupVerifyScreenState extends ConsumerState<SetupVerifyScreen> {
  final _formKey = GlobalKey<RecoveryVerifyFormState>();
  bool _isError = false;
  bool _isButtonEnabled = false;

  void _handleVerify() {
    final userWords = _formKey.currentState?.values ?? [];
    final success = ref
        .read(vaultSetupProvider.notifier)
        .verifyPhrase(userWords);

    if (success) {
      unawaited(ref.read(vaultSetupProvider.notifier).commitSetup());
    } else {
      setState(() => _isError = true);
      unawaited(_formKey.currentState?.shake());
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(vaultSetupProvider);

    return FlowScaffold(
      body: Column(
        children: [
          Text(
            context.t.seed.verify_title,
            style: context.textTheme.displayLarge,
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: sizes.betweenTitleAndSub),

          Text(
            context.t.seed.verify_desc,
            style: context.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 24),
          const Spacer(),

          RecoveryVerifyForm(
            key: _formKey,
            indices: state.verifyIndecies,
            isError: _isError,
            onChanged: () => setState(() {
              _isError = false;
              _isButtonEnabled =
                  _formKey.currentState?.values.every((v) => v.isNotEmpty) ??
                  false;
            }),
          ),

          const SizedBox(height: 24),
          const Spacer(),

          Image.asset(
            AppAssets.logo,
            height: sizes.largeImageHeight,
            width: sizes.largeImageWidth,
            fit: BoxFit.contain,
          ),

          const SizedBox(height: 24),
          const Spacer(),

          WideFilledButton(
            onPressed: _isButtonEnabled ? _handleVerify : null,
            child: Text(context.t.common.register),
          ),
        ],
      ),
    );
  }
}
