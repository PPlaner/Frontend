import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/core/ui/widgets/back_app_bar.dart';
import 'package:frontend/features/vault/presentation/navigation/vault_setup_routes.dart';
import 'package:frontend/features/vault/presentation/notifiers/vault_setup_notifier.dart';
import 'package:frontend/features/vault/presentation/widgets/recovery_phrase_display.dart';
import 'package:frontend/features/vault/presentation/widgets/safe_padding.dart';
import 'package:frontend/i18n/strings.g.dart';

class SetupRecoveryScreen extends ConsumerWidget {
  const SetupRecoveryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final colors = AppColors.of(context);

    final phrase = ref.watch(vaultSetupProvider).generatedRecoveryPhrase;

    return Scaffold(
      appBar: const BackAppBar(),
      body: SafePadding(
        child: Column(
          children: [
            const SizedBox(height: 40),

            Text(
              context.t.seed.title,
              style: textTheme.displayLarge?.copyWith(fontSize: 28),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: AppColors.error.withValues(alpha: 0.2),
                ),
              ),
              child: Text(
                t.seed.warning,
                style: textTheme.bodySmall?.copyWith(
                  color: colors.textPrimary,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 32),

            Expanded(
              child: RecoveryPhraseDisplay(phrase: phrase),
            ),

            TextButton.icon(
              onPressed: () async {
                await Clipboard.setData(
                  ClipboardData(text: phrase.join(' ')),
                );
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(t.seed.copy_done)),
                );
              },
              icon: const Icon(
                Icons.copy_rounded,
                size: 18,
                color: AppColors.primary,
              ),
              label: Text(
                t.seed.copy,
                style: textTheme.labelMedium?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                  decorationColor: AppColors.primary,
                ),
              ),
            ),

            const SizedBox(height: 20),

            FilledButton(
              onPressed: () => const SetupVerifyRoute().push<void>(context),
              style: FilledButton.styleFrom(
                minimumSize: const Size(double.infinity, 56),
                backgroundColor: AppColors.primary,
              ),
              child: Text(
                context.t.seed.saved_button,
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
