import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/core/ui/widgets/back_app_bar.dart';
import 'package:frontend/features/vault/presentation/navigation/vault_setup_routes.dart';
import 'package:frontend/features/vault/presentation/widgets/safe_padding.dart';
import 'package:frontend/features/vault/presentation/widgets/unlock_method.dart';
import 'package:frontend/i18n/strings.g.dart';

class SetupMethodScreen extends ConsumerStatefulWidget {
  const SetupMethodScreen({super.key});

  @override
  ConsumerState<SetupMethodScreen> createState() => _SetupMethodScreenState();
}

class _SetupMethodScreenState extends ConsumerState<SetupMethodScreen> {
  String? _selectedMethodId;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = AppColors.of(context);

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: const BackAppBar(),
      body: SafePadding(
        child: Column(
          children: [
            const SizedBox(height: 20),

            Text(
              context.t.security_methods.title,
              style: textTheme.displayLarge?.copyWith(fontSize: 28),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 12),

            Text(
              context.t.security_methods.subtitle,
              style: textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 48),

            UnlockMethod(
              title: t.security_methods.pin_title,
              subtitle: t.security_methods.pin_sub,
              isSelected: _selectedMethodId == 'pin',
              onTap: () => setState(
                () => _selectedMethodId = 'pin',
              ),
            ),

            UnlockMethod(
              title: t.security_methods.pattern_title,
              subtitle: t.security_methods.pattern_sub,
              isSelected: _selectedMethodId == 'pattern',
              onTap: () => setState(
                () => _selectedMethodId = 'pattern',
              ),
            ),

            const Spacer(),

            FilledButton(
              onPressed: _selectedMethodId == null
                  ? null
                  : () {
                      switch (_selectedMethodId) {
                        case 'pin':
                          unawaited(const SetupPinRoute().push<void>(context));
                        case 'pattern':
                          unawaited(
                            const SetupPatternRoute().push<void>(context),
                          );
                        default:
                      }
                    },
              style: FilledButton.styleFrom(
                minimumSize: const Size(double.infinity, 56),
                backgroundColor: AppColors.primary,
              ),
              child: Text(
                t.common.next,
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
