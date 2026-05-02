import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/core/theme/theme_extensions.dart';
import 'package:frontend/core/ui/widgets/flow_scaffold.dart';
import 'package:frontend/core/utils/navigation_helper.dart';
import 'package:frontend/core/utils/validators.dart';
import 'package:frontend/features/auth/presentation/notifiers/auth_notifier.dart';
import 'package:frontend/features/auth/presentation/widgets/email_form_field.dart';
import 'package:frontend/features/auth/presentation/widgets/password_form_field.dart';
import 'package:frontend/features/auth/presentation/widgets/primary_button.dart';
import 'package:frontend/i18n/strings.g.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    super.dispose();
  }

  Future<void> _onRegister() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    await ref
        .read(authProvider.notifier)
        .register(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = AppColors.of(context);

    return FlowScaffold(
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              t.common.register,
              style: theme.textTheme.displayLarge?.copyWith(
                color: colors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 40),

            EmailFormField(controller: _emailController),

            const SizedBox(height: 16),

            PasswordFormField(controller: _passwordController),

            const SizedBox(height: 16),

            PasswordFormField(
              controller: _confirmPasswordController,
              hintText: t.widgets.confirm_password,
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
              isLoading: _isLoading,
              onPressed: _onRegister,
            ),

            const SizedBox(height: 24),

            Column(
              children: [
                Text(
                  t.widgets.have_account,
                  style: theme.textTheme.bodyMedium,
                ),

                const SizedBox(height: 4),

                GestureDetector(
                  onTap: () => context.safePop(),
                  child: Text(
                    context.t.common.login,
                    style: theme.textTheme.bodyMedium?.copyWith(
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
