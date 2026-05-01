import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/core/ui/widgets/back_app_bar.dart';
import 'package:frontend/core/utils/app_assets.dart';
import 'package:frontend/features/vault/presentation/notifiers/vault_setup_notifier.dart';
import 'package:frontend/features/vault/presentation/widgets/recovery_verify_form.dart';
import 'package:frontend/features/vault/presentation/widgets/safe_child_scroll.dart';
import 'package:frontend/i18n/strings.g.dart';

class SetupVerifyScreen extends ConsumerStatefulWidget {
  const SetupVerifyScreen({super.key});

  @override
  ConsumerState<SetupVerifyScreen> createState() => _SetupVerifyScreenState();
}

class _SetupVerifyScreenState extends ConsumerState<SetupVerifyScreen> {
  @override
  Widget build(BuildContext context) {
    final phrase = ref.read(vaultSetupProvider).generatedRecoveryPhrase;

    final textTheme = Theme.of(context).textTheme;
    final colors = AppColors.of(context);

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: const BackAppBar(),
      body: SafeChildScroll(
        child: Column(
          children: [
            const SizedBox(height: 10),

            Text(
              context.t.seed.verify_title,
              style: textTheme.displayLarge?.copyWith(fontSize: 28),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 12),

            Text(
              context.t.seed.verify_desc,
              style: textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 40),

            RecoveryVerifyForm(
              originalPhrase: phrase,
              onSuccess: ref.read(vaultSetupProvider.notifier).commitSetup,
            ),

            const SizedBox(height: 40),

            Image.asset(
              AppAssets.logo,
              height: 170,
              width: 170,
              fit: BoxFit.contain,
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
