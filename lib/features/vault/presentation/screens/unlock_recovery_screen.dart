import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/presentation/app_assets.dart';
import 'package:frontend/core/presentation/app_sizes.dart' as sizes;
import 'package:frontend/core/presentation/extensions/app_snackbar.dart';
import 'package:frontend/core/presentation/theme/theme_extensions.dart';
import 'package:frontend/core/presentation/widgets/flow_scaffold.dart';
import 'package:frontend/core/presentation/widgets/wide_filled_button.dart';
import 'package:frontend/features/vault/presentation/notifiers/vault_unlock_notifier.dart';
import 'package:frontend/features/vault/presentation/widgets/recovery_phrase_input.dart';
import 'package:frontend/i18n/strings.g.dart';

class UnlockRecoveryScreen extends ConsumerStatefulWidget {
  const UnlockRecoveryScreen({super.key});

  @override
  ConsumerState<UnlockRecoveryScreen> createState() =>
      _UnlockRecoveryScreenState();
}

class _UnlockRecoveryScreenState extends ConsumerState<UnlockRecoveryScreen> {
  List<String>? _enteredPhrase;

  void _onSubmit() =>
      ref.read(vaultUnlockProvider.notifier).unlockWithPhrase(_enteredPhrase!);

  @override
  Widget build(BuildContext context) {
    ref.listen(vaultUnlockProvider.select((state) => state.failure), (
      previous,
      next,
    ) {
      context.showSnackbarError('err: $next');
    });

    return FlowScaffold(
      body: Column(
        children: [
          Text(
            context.t.seed.login_title,
            style: context.textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: sizes.betweenTitleAndSub),

          Text(
            t.seed.login_subtitle,
            style: context.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 24),
          const Spacer(),

          RecoveryPhraseInput(
            onPhraseCompleted: (words) =>
                setState(() => _enteredPhrase = words),
            onPhraseIncomplete: () => setState(() => _enteredPhrase = null),
          ),

          const SizedBox(height: 24),
          const Spacer(),

          Image.asset(
            AppAssets.logo,
            height: sizes.smallImageHeight,
            width: sizes.smallImageWidth,
            fit: BoxFit.contain,
          ),

          const SizedBox(height: 24),
          const Spacer(),

          WideFilledButton(
            onPressed: _enteredPhrase != null ? _onSubmit : null,
            child: Text(context.t.common.login),
          ),
        ],
      ),
    );
  }
}
