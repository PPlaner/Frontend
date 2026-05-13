import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/constants/app_sizes.dart' as sizes;
import 'package:frontend/core/theme/theme_extensions.dart';
import 'package:frontend/core/ui/widgets/flow_scaffold.dart';
import 'package:frontend/core/ui/widgets/wide_filled_button.dart';
import 'package:frontend/core/utils/app_assets.dart';
import 'package:frontend/core/utils/app_snackbar.dart';
import 'package:frontend/features/vault/presentation/navigation/vault_setup_routes.dart';
import 'package:frontend/features/vault/presentation/notifiers/vault_setup_notifier.dart';
import 'package:frontend/features/vault/presentation/widgets/pattern_lock_view.dart';
import 'package:frontend/i18n/strings.g.dart';

class SetupPatternScreen extends ConsumerStatefulWidget {
  const SetupPatternScreen({super.key});

  @override
  ConsumerState<SetupPatternScreen> createState() => _SetupPatternScreenState();
}

class _SetupPatternScreenState extends ConsumerState<SetupPatternScreen> {
  List<int>? _pattern;

  void _onSubmit() {
    ref.read(vaultSetupProvider.notifier).setupPattern(_pattern!);
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
              context.t.setup.pattern_create,
              style: context.textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: sizes.betweenTitleAndSub),

            Text(
              context.t.setup.pattern_desc_setup,
              style: context.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),

            const Spacer(),

            PatternLockView(
              onPatternChanged: (pattern) => setState(() => _pattern = pattern),
              onPatternTooShort: () => context.showSnackbarError(
                context.t.setup.pattern_short,
              ),
            ),

            const Spacer(),

            Image.asset(
              AppAssets.logo,
              height: sizes.largeImageHeight,
              width: sizes.largeImageWidth,
              fit: BoxFit.contain,
            ),

            const Spacer(),

            WideFilledButton(
              onPressed: (_pattern != null && _pattern!.length >= 4)
                  ? _onSubmit
                  : null,
              child: Text(context.t.common.register),
            ),
          ],
        ),
      ),
    );
  }
}
