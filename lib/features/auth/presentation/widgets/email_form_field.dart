import 'package:flutter/material.dart';
import 'package:frontend/core/theme/theme_extensions.dart';
import 'package:frontend/core/utils/validators.dart';
import 'package:frontend/i18n/strings.g.dart';

class EmailFormField extends StatelessWidget {
  const EmailFormField({required this.controller, super.key});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      style: context.textTheme.bodyLarge,
      decoration: InputDecoration(hintText: context.t.widgets.email),
      validator: (v) => emailValidator(
        v,
        emptyError: context.t.widgets.email_error,
        formatError: context.t.widgets.email_format_error,
      ),
    );
  }
}
