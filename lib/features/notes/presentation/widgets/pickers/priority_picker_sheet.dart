import 'package:flutter/material.dart';
import 'package:frontend/core/theme/theme_extensions.dart';
import 'package:frontend/features/notes/domain/task_priority.dart';
import 'package:frontend/features/notes/presentation/widgets/base_bottom_sheet_layout.dart';
import 'package:frontend/i18n/strings.g.dart';

class PriorityPickerSheet extends StatelessWidget {
  const PriorityPickerSheet({
    required this.current,
    required this.onSelected,
    super.key,
  });

  final TaskPriority current;
  final ValueChanged<TaskPriority> onSelected;

  @override
  Widget build(BuildContext context) {
    return BaseBottomSheetLayout(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      title: Text(
        context.t.task.choosePriority,
        style: context.textTheme.titleLarge,
      ),
      children: [
        ...TaskPriority.values.map(
          (p) => _PriorityTile(
            priority: p,
            isCurrent: p == current,
            onTap: () => onSelected(p),
          ),
        ),
      ],
    );
  }
}

class _PriorityTile extends StatelessWidget {
  const _PriorityTile({
    required this.priority,
    required this.isCurrent,
    required this.onTap,
  });

  final TaskPriority priority;
  final bool isCurrent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        Icons.flag,
        size: 22,
        color: priority == TaskPriority.none
            ? context.theme.hintColor
            : priority.color,
      ),
      title: Text(
        priority.label(context.t),
        style: context.textTheme.titleMedium?.copyWith(
          color: isCurrent
              ? context.colorScheme.primary
              : context.colorScheme.onSurface,
        ),
      ),
      trailing: isCurrent
          ? Icon(
              Icons.check,
              color: context.colorScheme.primary,
              size: 20,
            )
          : null,
      onTap: onTap,
    );
  }
}
