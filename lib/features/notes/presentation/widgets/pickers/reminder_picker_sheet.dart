import 'package:flutter/material.dart';
import 'package:frontend/core/presentation/theme/theme_extensions.dart';
import 'package:frontend/features/notes/presentation/helpers.dart';
import 'package:frontend/features/notes/presentation/widgets/base_bottom_sheet_layout.dart';
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
    return BaseBottomSheetLayout(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      header: Text(
        context.t.task.chooseReminder,
        style: context.textTheme.titleLarge,
      ),
      children: [
        ..._options.map(
          (opt) => _ReminderTile(
            option: opt,
            isSelected: opt == current,
            onTap: () => onSelected(opt),
          ),
        ),
      ],
    );
  }
}

class _ReminderTile extends StatelessWidget {
  const _ReminderTile({
    required this.option,
    required this.isSelected,
    required this.onTap,
  });

  final int? option;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        option == null
            ? Icons.notifications_off_outlined
            : Icons.notifications_outlined,
        color: isSelected
            ? context.colorScheme.primary
            : context.theme.hintColor,
        size: 22,
      ),
      title: Text(
        option == null
            ? context.t.task.noReminder
            : reminderLabel(option!, context.t),
        style: context.textTheme.titleMedium?.copyWith(
          color: isSelected
              ? context.colorScheme.primary
              : context.colorScheme.onSurface,
        ),
      ),
      trailing: isSelected
          ? Icon(
              Icons.check,
              size: 20,
              color: context.colorScheme.primary,
            )
          : null,
      onTap: onTap,
    );
  }
}
