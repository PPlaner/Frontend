import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/core/ui/widgets/back_app_bar.dart';
import 'package:frontend/i18n/strings.g.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key, this.email});
  final String? email;

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  final _codeController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _onConfirm() async {
    final code = _codeController.text.trim();
    if (code.isEmpty || code.length < 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.email_verify.code_error)),
      );
      return;
    }
    setState(() => _isLoading = true);
    // TODO: виклик AuthBloc / AuthRepository для верифікації коду
    await Future.delayed(const Duration(seconds: 2));
    setState(() => _isLoading = false);
    if (!mounted) return;
    Navigator.of(context).pushNamedAndRemoveUntil(
      '/security_method',
      (route) => false,
    );
  }

  Future<void> _onResend() async {
    // TODO: повторне відправлення коду
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(t.email_verify.resend_success)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = AppColors.of(context);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: const BackAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              Text(
                t.email_verify.title,
                style: theme.textTheme.displayLarge, // колір вже в textTheme
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              if (widget.email != null)
                Text(
                  '${t.email_verify.sent_to}\n${widget.email}',
                  style: theme.textTheme.bodyMedium, // колір вже в textTheme
                  textAlign: TextAlign.center,
                ),
              const SizedBox(height: 40),
              TextFormField(
                controller: _codeController,
                keyboardType: TextInputType.number,
                style: theme.textTheme.bodyLarge,
                decoration: InputDecoration(
                  hintText: t.email_verify.code_hint,
                  hintStyle: theme.textTheme.bodyLarge?.copyWith(
                    color: colors.textSecondary,
                  ),
                  filled: true,
                  fillColor: colors.surface,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: colors.cardBorder),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(color: AppColors.primary),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(color: AppColors.error),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(color: AppColors.error),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              FilledButton(
                onPressed: _isLoading ? null : _onConfirm,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary, // явно статичний
                  minimumSize: const Size(double.infinity, 56),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        t.common.confirm,
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: Colors.white,
                        ),
                      ),
              ),
              const SizedBox(height: 24),
              Center(
                child: TextButton(
                  onPressed: _onResend,
                  child: Text(
                    t.email_verify.resend,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.primary,
                      decoration: TextDecoration.underline,
                      decorationColor: AppColors.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

