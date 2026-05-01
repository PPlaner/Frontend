import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/core/ui/widgets/back_app_bar.dart';
import 'package:frontend/core/utils/app_assets.dart';
import 'package:frontend/features/vault/presentation/notifiers/vault_unlock_notifier.dart';
import 'package:frontend/features/vault/presentation/widgets/recovery_phrase_input.dart';
import 'package:frontend/features/vault/presentation/widgets/safe_padding.dart';
import 'package:frontend/i18n/strings.g.dart';

class UnlockRecoveryScreen extends ConsumerStatefulWidget {
  const UnlockRecoveryScreen({super.key});

  @override
  ConsumerState<UnlockRecoveryScreen> createState() =>
      _UnlockRecoveryScreenState();
}

class _UnlockRecoveryScreenState extends ConsumerState<UnlockRecoveryScreen> {
  List<String>? _enteredPhrase;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    ref.listen(vaultUnlockProvider.select((state) => state.failure), (
      previous,
      next,
    ) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('err: $next')));
    });

    return Scaffold(
      appBar: const BackAppBar(),
      body: SafePadding(
        child: Column(
          children: [
            const SizedBox(height: 20),

            Text(
              context.t.seed.login_title,
              style: textTheme.displayLarge?.copyWith(fontSize: 28),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 12),

            Text(
              t.seed.login_subtitle,
              style: textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 24),

            Expanded(
              child: RecoveryPhraseInput(
                onPhraseCompleted: (words) =>
                    setState(() => _enteredPhrase = words),
                onPhraseIncomplete: () => setState(() => _enteredPhrase = null),
              ),
            ),

            const SizedBox(height: 16),

            Image.asset(
              AppAssets.logo,
              height: 80,
              width: 80,
              fit: BoxFit.contain,
            ),

            const SizedBox(height: 16),

            FilledButton(
              onPressed: _enteredPhrase != null
                  ? () => ref
                        .read(vaultUnlockProvider.notifier)
                        .unlockWithPhrase(_enteredPhrase!)
                  : null,
              style: FilledButton.styleFrom(
                minimumSize: const Size(double.infinity, 56),
                backgroundColor: AppColors.primary,
              ),
              child: Text(
                context.t.common.login,
                style: textTheme.labelLarge?.copyWith(color: Colors.white),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
