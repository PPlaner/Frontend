import 'package:flutter/material.dart';
import 'package:frontend/core/theme/theme_extensions.dart';
import 'package:frontend/features/notes/domain/task_priority.dart';
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
            Text(t.task.choosePriority, style: context.textTheme.titleLarge),
            const SizedBox(height: 8),
            ...TaskPriority.values.map(
              (p) => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(
                  Icons.flag,
                  color: p == TaskPriority.none
                      ? context.theme.hintColor
                      : p.color,
                  size: 22,
                ),
                title: Text(
                  p.label(t),
                  style: context.textTheme.titleMedium?.copyWith(
                    color: current == p
                        ? context.colorScheme.primary
                        : context.colorScheme.onSurface,
                  ),
                ),
                trailing: current == p
                    ? Icon(
                        Icons.check,
                        color: context.colorScheme.primary,
                        size: 20,
                      )
                    : null,
                onTap: () => onSelected(p),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
