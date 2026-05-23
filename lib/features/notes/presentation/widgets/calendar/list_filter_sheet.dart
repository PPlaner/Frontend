import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/presentation/theme/theme_extensions.dart';
import 'package:frontend/features/notes/domain/constants.dart';
import 'package:frontend/features/notes/presentation/notifiers/projects_notifier.dart';
import 'package:frontend/features/notes/presentation/notifiers/ui_state.dart';
import 'package:frontend/features/notes/presentation/widgets/base_bottom_sheet_layout.dart';
import 'package:frontend/i18n/strings.g.dart';

class ListFilterSheet extends ConsumerWidget {
  const ListFilterSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projects = ref.watch(projectsProvider).value ?? [];
    final selectedProjectId = ref.watch(selectedProjectIdProvider);

    return BaseBottomSheetLayout(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      header: Text(
        context.t.calendar.taskCategory,
        style: context.textTheme.titleLarge,
      ),
      children: [
        _ProjectTile(
          title: context.t.category.all,
          emoji: '🗂️',
          isSelected: selectedProjectId == allProjectsId,
          onTap: () =>
              ref.read(selectedProjectIdProvider.notifier).set(allProjectsId),
        ),

        if (projects.isNotEmpty) const Divider(),

        ...projects.map(
          (project) => _ProjectTile(
            title: project.title,
            emoji: project.emoji,
            isSelected: selectedProjectId == project.id,
            onTap: () =>
                ref.read(selectedProjectIdProvider.notifier).set(project.id),
          ),
        ),
      ],
    );
  }
}

class _ProjectTile extends StatelessWidget {
  const _ProjectTile({
    required this.title,
    required this.emoji,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final String emoji;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Text(emoji, style: const TextStyle(fontSize: 20)),
      title: Text(
        title,
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
