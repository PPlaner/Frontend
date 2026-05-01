import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/core/ui/widgets/back_app_bar.dart';
import 'package:frontend/core/utils/app_assets.dart';
import 'package:frontend/core/utils/app_snackbar.dart';
import 'package:frontend/features/vault/presentation/notifiers/vault_unlock_notifier.dart';
import 'package:frontend/features/vault/presentation/widgets/pattern_lock_view.dart';
import 'package:frontend/features/vault/presentation/widgets/safe_padding.dart';
import 'package:frontend/i18n/strings.g.dart';

class UnlockPatternScreen extends ConsumerStatefulWidget {
  const UnlockPatternScreen({super.key});

  @override
  ConsumerState<UnlockPatternScreen> createState() =>
      _UnlockPatternScreenState();
}

class _UnlockPatternScreenState extends ConsumerState<UnlockPatternScreen> {
  List<int>? _pattern;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = AppColors.of(context);

    return PopScope(
      onPopInvokedWithResult: (didPop, _) =>
          didPop ? ref.invalidate(vaultUnlockProvider) : null,
      child: Scaffold(
        backgroundColor: colors.surface,
        appBar: const BackAppBar(),
        body: SafePadding(
          child: Column(
            children: [
              const SizedBox(height: 20),

              Text(
                context.t.setup.pattern_enter,
                style: textTheme.displayLarge?.copyWith(fontSize: 28),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 12),

              Text(
                t.setup.pattern_desc_login,
                style: textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),

              const Spacer(),

              SizedBox(
                height: 300,
                child: PatternLockView(
                  onPatternChanged: (pattern) =>
                      setState(() => _pattern = pattern),
                  onPatternTooShort: () => context.showSnackbarError(
                    context.t.setup.pattern_short,
                  ),
                ),
              ),

              const Spacer(),

              Image.asset(
                AppAssets.logo,
                height: 160,
                width: 160,
                fit: BoxFit.contain,
              ),

              const Spacer(),

              FilledButton(
                onPressed: (_pattern != null && _pattern!.length >= 4)
                    ? () => ref
                          .read(vaultUnlockProvider.notifier)
                          .unlockWithPattern(_pattern!)
                    : null,
                style: FilledButton.styleFrom(
                  minimumSize: const Size(double.infinity, 56),
                  backgroundColor: AppColors.primary, // статичний
                ),
                child: Text(
                  t.common.login,
                  style: textTheme.labelLarge?.copyWith(color: Colors.white),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
