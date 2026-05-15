import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/features/notes/domain/constants.dart';
import 'package:frontend/features/notes/presentation/notifiers/projects_notifier.dart';
import 'package:frontend/features/notes/presentation/notifiers/ui_state.dart';
import 'package:frontend/i18n/strings.g.dart';

class ListFilterSheet extends ConsumerWidget {
  const ListFilterSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lists = ref.watch(projectsProvider).value ?? [];
    final selectedProjectId = ref.watch(selectedProjectIdProvider);

    final textTheme = Theme.of(context).textTheme;
    final colors = AppColors.of(context);
    final t = context.t;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
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
            const SizedBox(height: 20),
            Text(t.calendar.taskCategory, style: textTheme.titleLarge),
            const SizedBox(height: 16),

            // "Всі списки" — перший елемент
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Text('🗂️', style: TextStyle(fontSize: 20)),
              title: Text(
                t.category.all,
                style: textTheme.titleMedium?.copyWith(
                  color: selectedProjectId == allProjectsId
                      ? AppColors.primary
                      : colors.textPrimary,
                ),
              ),
              trailing: selectedProjectId == allProjectsId
                  ? const Icon(Icons.check, color: AppColors.primary, size: 20)
                  : null,
              onTap: () => ref
                  .read(selectedProjectIdProvider.notifier)
                  .set(allProjectsId),
            ),

            if (lists.isNotEmpty) const Divider(),

            // Користувацькі списки
            ...lists.map(
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
                onTap: () =>
                    ref.read(selectedProjectIdProvider.notifier).set(list.id),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
