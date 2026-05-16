import 'package:flutter/material.dart';
import 'package:frontend/core/theme/theme_extensions.dart';
import 'package:frontend/features/notes/presentation/helpers.dart';
import 'package:frontend/i18n/strings.g.dart';

class ReminderPickerSheet extends StatelessWidget {
  const ReminderPickerSheet({
    required this.current,
    required this.onSelected,
    super.key,
  });

  final int? current;
  final ValueChanged<int?> onSelected;

  static const List<int?> _options = [
    null, // без нагадування
    0, // у момент
    10, // за 10 хв
    30, // за 30 хв
    60, // за 1 год
    1440, // за 1 день
  ];

  @override
  Widget build(BuildContext context) {
    final t = context.t;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: context.theme.dividerColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(t.task.chooseReminder, style: context.textTheme.titleLarge),
            const SizedBox(height: 8),
            ..._options.map(
              (opt) {
                final isSelected = opt == current;
                final label = opt == null
                    ? t.task.noReminder
                    : reminderLabel(opt, t);
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    opt == null
                        ? Icons.notifications_off_outlined
                        : Icons.notifications_outlined,
                    color: isSelected
                        ? context.colorScheme.primary
                        : context.theme.hintColor,
                    size: 22,
                  ),
                  title: Text(
                    label,
                    style: context.textTheme.titleMedium?.copyWith(
                      color: isSelected
                          ? context.colorScheme.primary
                          : context.colorScheme.onSurface,
                    ),
                  ),
                  trailing: isSelected
                      ? Icon(
                          Icons.check,
                          color: context.colorScheme.primary,
                          size: 20,
                        )
                      : null,
                  onTap: () => onSelected(opt),
                );
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
