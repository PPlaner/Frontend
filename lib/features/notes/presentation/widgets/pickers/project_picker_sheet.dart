import 'package:flutter/material.dart';
import 'package:frontend/core/theme/theme_extensions.dart';
import 'package:frontend/features/notes/domain/entities/project.dart';
import 'package:frontend/i18n/strings.g.dart';

class ProjectPickerSheet extends StatelessWidget {
  const ProjectPickerSheet({
    required this.projects,
    required this.selectedProjectId,
    required this.onSelected,
    super.key,
  });

  final List<Project> projects;
  final String? selectedProjectId;
  final ValueChanged<String?> onSelected;

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
            Text(t.task.chooseList, style: context.textTheme.titleLarge),
            const SizedBox(height: 8),

            // Без списку
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Text('📋', style: TextStyle(fontSize: 20)),
              title: Text(
                t.task.noList,
                style: context.textTheme.titleMedium?.copyWith(
                  color: selectedProjectId == null
                      ? context.colorScheme.primary
                      : context.colorScheme.onSurface,
                ),
              ),
              trailing: selectedProjectId == null
                  ? Icon(
                      Icons.check,
                      color: context.colorScheme.primary,
                      size: 20,
                    )
                  : null,
              onTap: () => onSelected(null),
            ),

            if (projects.isNotEmpty) Divider(color: context.theme.dividerColor),

            ...projects.map(
              (list) => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Text(list.emoji, style: const TextStyle(fontSize: 20)),
                title: Text(
                  list.title,
                  style: context.textTheme.titleMedium?.copyWith(
                    color: selectedProjectId == list.id
                        ? context.colorScheme.primary
                        : context.colorScheme.onSurface,
                  ),
                ),
                trailing: selectedProjectId == list.id
                    ? Icon(
                        Icons.check,
                        color: context.colorScheme.primary,
                        size: 20,
                      )
                    : null,
                onTap: () => onSelected(list.id),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
