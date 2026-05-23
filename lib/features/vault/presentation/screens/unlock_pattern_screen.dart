import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/presentation/app_assets.dart';
import 'package:frontend/core/presentation/app_sizes.dart' as sizes;
import 'package:frontend/core/presentation/extensions/app_snackbar.dart';
import 'package:frontend/core/presentation/theme/theme_extensions.dart';
import 'package:frontend/core/presentation/widgets/flow_scaffold.dart';
import 'package:frontend/core/presentation/widgets/wide_filled_button.dart';
import 'package:frontend/features/vault/presentation/notifiers/vault_unlock_notifier.dart';
import 'package:frontend/features/vault/presentation/widgets/pattern_lock_view.dart';
import 'package:frontend/i18n/strings.g.dart';

class UnlockPatternScreen extends ConsumerStatefulWidget {
  const UnlockPatternScreen({super.key});

  @override
  ConsumerState<UnlockPatternScreen> createState() =>
      _UnlockPatternScreenState();
}

class _UnlockPatternScreenState extends ConsumerState<UnlockPatternScreen> {
  List<int>? _pattern;

  void _onSubmit() =>
      ref.read(vaultUnlockProvider.notifier).unlockWithPattern(_pattern!);

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, _) =>
          didPop ? ref.invalidate(vaultUnlockProvider) : null,
      child: FlowScaffold(
        body: Column(
          children: [
            Text(
              context.t.setup.pattern_enter,
              style: context.textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: sizes.betweenTitleAndSub),

            Text(
              context.t.setup.pattern_desc_login,
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
              child: Text(context.t.common.login),
            ),
          ],
        ),
      ),
    );
  }
}
