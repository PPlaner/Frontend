import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/theme/theme_extensions.dart';
import 'package:frontend/core/ui/widgets/flow_scaffold.dart';
import 'package:frontend/core/utils/app_snackbar.dart';
import 'package:frontend/core/utils/navigation_helper.dart';
import 'package:frontend/core/utils/validators.dart';
import 'package:frontend/features/auth/presentation/navigation/auth_routes.dart';
import 'package:frontend/features/auth/presentation/notifiers/auth_notifier.dart';
import 'package:frontend/features/auth/presentation/widgets/email_form_field.dart';
import 'package:frontend/features/auth/presentation/widgets/password_form_field.dart';
import 'package:frontend/features/auth/presentation/widgets/primary_button.dart';
import 'package:frontend/i18n/strings.g.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({required this.source, super.key});

  final String source;

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _passwordController.text = '11111111';
    _confirmPasswordController.text = '11111111';
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    super.dispose();
  }

  Future<void> _onRegister() async {
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();

    final result = await ref
        .read(authProvider.notifier)
        .setupRegister(
          email,
          _passwordController.text.trim(),
        );

    if (!mounted) return;

    switch (result) {
      case RegisterResult.codeSent:
        context.showSnackBarInfo(context.t.auth.codeSent(email: email));
        unawaited(
          EmailVerificationRoute(source: widget.source).push<void>(context),
        );
      case RegisterResult.alreadySent:
        unawaited(
          EmailVerificationRoute(source: widget.source).push<void>(context),
        );
      case RegisterResult.processing:
      case RegisterResult.failure:
        final failure = ref.read(authProvider).failure;
        if (failure != null) context.showSnackbarError('$failure');
    }
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
              context.t.common.register,
              style: context.textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 40),

            EmailFormField(controller: _emailController),

            const SizedBox(height: 16),

            PasswordFormField(controller: _passwordController),

            const SizedBox(height: 16),

            PasswordFormField(
              controller: _confirmPasswordController,
              hintText: context.t.widgets.confirm_password,
              validator: (v) => passwordConfirmValidator(
                v,
                password: _passwordController.text,
                emptyError: context.t.widgets.confirm_password,
                noMatchError: context.t.widgets.passwords_not_match,
              ),
            ),

            const SizedBox(height: 32),

            PrimaryButton(
              label: t.common.register,
              isLoading: isProcessing,
              onPressed: _onRegister,
            ),

            const SizedBox(height: 24),

            Column(
              children: [
                Text(
                  context.t.widgets.have_account,
                  style: context.textTheme.bodyMedium,
                ),

                const SizedBox(height: 4),

                GestureDetector(
                  onTap: () => context.safePop(),
                  child: Text(
                    context.t.common.login,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: context.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                      decorationColor: context.colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
