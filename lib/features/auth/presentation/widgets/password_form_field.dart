import 'package:flutter/material.dart';
import 'package:frontend/core/theme/theme_extensions.dart';
import 'package:frontend/core/utils/validators.dart';
import 'package:frontend/i18n/strings.g.dart';

class PasswordFormField extends StatefulWidget {
  const PasswordFormField({
    required this.controller,
    this.hintText,
    this.validator,
    super.key,
  });

  final TextEditingController controller;
  final String? hintText;
  final String? Function(String?)? validator;

  @override
  State<PasswordFormField> createState() => _PasswordFormFieldState();
}

class _PasswordFormFieldState extends State<PasswordFormField> {
  bool _obscureInput = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _obscureInput,
      style: context.textTheme.bodyLarge,
      decoration: InputDecoration(
        hintText: widget.hintText ?? context.t.widgets.password,
        suffixIcon: IconButton(
          icon: Icon(
            _obscureInput
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
          ),
          onPressed: () => setState(() => _obscureInput = !_obscureInput),
        ),
      ),
      validator:
          widget.validator ??
          (v) => passwordValidator(
            v,
            emptyError: context.t.widgets.password_error,
            lengthError: context.t.widgets.password_length_error,
          ),
    );
  }
}
