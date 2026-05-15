import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_colors.dart';
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
    final textTheme = Theme.of(context).textTheme;
    final colors = AppColors.of(context);
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
                  color: colors.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(t.task.chooseList, style: textTheme.titleLarge),
            const SizedBox(height: 8),

            // Без списку
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Text('📋', style: TextStyle(fontSize: 20)),
              title: Text(
                t.task.noList,
                style: textTheme.titleMedium?.copyWith(
                  color: selectedProjectId == null
                      ? AppColors.primary
                      : colors.textPrimary,
                ),
              ),
              trailing: selectedProjectId == null
                  ? const Icon(Icons.check, color: AppColors.primary, size: 20)
                  : null,
              onTap: () => onSelected(null),
            ),

            if (projects.isNotEmpty) Divider(color: colors.divider),

            ...projects.map(
              (list) => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Text(list.emoji, style: const TextStyle(fontSize: 20)),
                title: Text(
                  list.title,
                  style: textTheme.titleMedium?.copyWith(
                    color: selectedProjectId == list.id
                        ? AppColors.primary
                        : colors.textPrimary,
                  ),
                ),
                trailing: selectedProjectId == list.id
                    ? const Icon(
                        Icons.check,
                        color: AppColors.primary,
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
