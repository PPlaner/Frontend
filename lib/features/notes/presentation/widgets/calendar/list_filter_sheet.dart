import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/theme/theme_extensions.dart';
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
                  color: context.theme.dividerColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(t.calendar.taskCategory, style: context.textTheme.titleLarge),
            const SizedBox(height: 16),

            // "Всі списки" — перший елемент
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Text('🗂️', style: TextStyle(fontSize: 20)),
              title: Text(
                t.category.all,
                style: context.textTheme.titleMedium?.copyWith(
                  color: selectedProjectId == allProjectsId
                      ? context.colorScheme.primary
                      : context.colorScheme.onSurface,
                ),
              ),
              trailing: selectedProjectId == allProjectsId
                  ? Icon(
                      Icons.check,
                      color: context.colorScheme.primary,
                      size: 20,
                    )
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
