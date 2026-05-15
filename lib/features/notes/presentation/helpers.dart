import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/i18n/strings.g.dart';

String reminderLabel(int minutes, Translations t) {
  if (minutes == 0) return t.task.reminderAtTime;
  if (minutes < 60) return t.task.reminderMinutes(n: minutes);
  if (minutes < 1440) return t.task.reminderHours(n: minutes ~/ 60);
  return t.task.reminderDays(n: minutes ~/ 1440);
}

String formatDateTime(DateTime date, TimeOfDay? time, Translations t) {
  final monthName = t.calendar.months[date.month - 1];
  final dateStr = '${date.day} $monthName ${date.year}';
  if (time == null) return dateStr;
  final h = time.hour.toString().padLeft(2, '0');
  final m = time.minute.toString().padLeft(2, '0');
  return '$dateStr  $h:$m';
}

Future<bool> confirmDeletion(
  BuildContext context,
  String title,
  String message,
) async {
  final textTheme = Theme.of(context).textTheme;
  final result = await showDialog<bool>(
    context: context,
    builder: (ctx) {
      final t = ctx.t;
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        actionsAlignment: MainAxisAlignment.center,
        title: Text(
          // context.t.home.deleteTask,
          title,
          textAlign: TextAlign.center,
          style: textTheme.titleLarge,
        ),
        content: Text(
          message /*t.home.deleteTaskMessage*/,
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(t.common.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: Text(t.common.delete),
          ),
        ],
      );
    },
  );
  return result ?? false;
}

String extractPlainText(String jsonOrText) {
  if (jsonOrText.isEmpty) return '';
  try {
    if (jsonOrText.trim().startsWith('[')) {
      final decoded = jsonDecode(jsonOrText) as List<dynamic>;
      final doc = quill.Document.fromJson(decoded);
      return doc.toPlainText().trim();
    }
    return jsonOrText;
  } on FormatException {
    return jsonOrText;
  }
}
