import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/config/user_config.dart';
import 'package:frontend/core/theme/theme_extensions.dart';
import 'package:frontend/core/ui/widgets/flow_scaffold.dart';
import 'package:frontend/core/utils/app_snackbar.dart';
import 'package:frontend/core/utils/navigation_helper.dart';
import 'package:frontend/features/auth/presentation/navigation/auth_navigator.dart';
import 'package:frontend/features/auth/presentation/notifiers/auth_notifier.dart';
import 'package:frontend/features/auth/presentation/widgets/code_form_field.dart';
import 'package:frontend/features/auth/presentation/widgets/primary_button.dart';
import 'package:frontend/i18n/strings.g.dart';

class EmailVerificationScreen extends ConsumerStatefulWidget {
  const EmailVerificationScreen({required this.source, super.key});

  final String source;

  @override
  ConsumerState<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState
    extends ConsumerState<EmailVerificationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();

    super.dispose();
  }

  Future<void> _onConfirm() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await ref
        .read(authProvider.notifier)
        .confirmRegister(_codeController.text.trim());

    if (!mounted) return;

    if (success) {
      context.showSnackBarSuccess(context.t.auth.registerSuccess);
      await ref.read(userPreferencesProvider).setAuthenticatedBefore(true);

      if (widget.source == 'inApp') {
        ref.read(authNavigatorProvider).onAuthCompleted();
      }
    } else {
      final failure = ref.read(authProvider).failure;
      if (failure != null) context.showSnackbarError('$failure');
    }
  }

  Future<void> _onResend() async {
    // TODO: повторне відправлення коду
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(t.email_verify.resend_success)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isProcessing = ref.watch(
      authProvider.select((state) => state.isProcessing),
    );

    return FlowScaffold(
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              context.t.email_verify.title,
              style: context.textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 40),

            CodeFormField(controller: _codeController),

            const SizedBox(height: 32),

            PrimaryButton(
              label: context.t.common.confirm,
              isLoading: isProcessing,
              onPressed: _onConfirm,
            ),

            const SizedBox(height: 24),

            Center(
              child: TextButton(
                onPressed: _onResend,
                child: Text(
                  context.t.email_verify.resend,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: context.colorScheme.primary,
                    decoration: TextDecoration.underline,
                    decorationColor: context.colorScheme.primary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
