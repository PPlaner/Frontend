import 'package:flutter/material.dart';
import 'package:frontend/core/presentation/theme/theme_extensions.dart';
import 'package:frontend/core/presentation/validators.dart';
import 'package:frontend/i18n/strings.g.dart';

class CodeFormField extends StatelessWidget {
  const CodeFormField({required this.controller, super.key});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: context.textTheme.bodyLarge,
      decoration: InputDecoration(hintText: context.t.email_verify.code_hint),
      validator: (v) => verificationCodeValidator(
        v,
        emptyError: context.t.email_verify.code_error,
        lengthError: context.t.email_verify.code_error,
      ),
    );
  }
}
