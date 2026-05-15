import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/features/notes/domain/constants.dart';
import 'package:frontend/features/notes/domain/entities/project.dart';
import 'package:frontend/features/notes/presentation/helpers.dart';
import 'package:frontend/features/notes/presentation/notifiers/projects_notifier.dart';
import 'package:frontend/features/notes/presentation/notifiers/ui_state.dart';
import 'package:frontend/features/notes/presentation/widgets/projects/create_project_sheet.dart';
import 'package:frontend/i18n/strings.g.dart';

class DrawerProjectItem extends ConsumerWidget {
  const DrawerProjectItem({
    required this.project,
    required this.count,
    super.key,
  });

  final Project project;
  final int? count;

  Future<void> _openEditList(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CreateProjectSheet(initialProject: project),
    );
  }

  Future<void> _deleteList(BuildContext context, WidgetRef ref) async {
    final confirmed = await confirmDeletion(
      context,
      context.t.home.deleteListTitle,
      context.t.home.deleteListMessage,
    );

    if (confirmed) {
      await ref.read(projectsProvider.notifier).deleteProject(project);

      if (ref.read(selectedProjectIdProvider) == project.id) {
        ref.read(selectedProjectIdProvider.notifier).set(todayProjectId);
      }
    }
  }

  Future<void> _showContextMenu(BuildContext context, WidgetRef ref) async {
    final t = context.t;
    final renderBox = context.findRenderObject()! as RenderBox;
    final overlay =
        Navigator.of(context).overlay!.context.findRenderObject()! as RenderBox;
    final offset = renderBox.localToGlobal(
      Offset(renderBox.size.width - 8, renderBox.size.height / 2),
      ancestor: overlay,
    );

    final position = RelativeRect.fromLTRB(
      offset.dx,
      offset.dy - 20,
      overlay.size.width - offset.dx,
      overlay.size.height - offset.dy,
    );

    await showMenu<String>(
      context: context,
      position: position,
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      items: [
        PopupMenuItem<String>(
          value: 'edit',
          child: Row(
            children: [
              Icon(
                Icons.edit_outlined,
                size: 20,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              const SizedBox(width: 12),
              Text(
                t.home.editList,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'delete',
          child: Row(
            children: [
              const Icon(
                Icons.delete_outline,
                size: 20,
                color: AppColors.error,
              ),
              const SizedBox(width: 12),
              Text(
                t.home.deleteList,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(color: AppColors.error),
              ),
            ],
          ),
        ),
      ],
    ).then((value) {
      if (!context.mounted) return;

      if (value == 'edit') unawaited(_openEditList(context));
      if (value == 'delete') unawaited(_deleteList(context, ref));
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSelected = ref.watch(selectedProjectIdProvider) == project.id;

    final colors = AppColors.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () =>
            ref.read(selectedProjectIdProvider.notifier).set(project.id),
        onLongPress: () => _showContextMenu(context, ref),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          decoration: BoxDecoration(
            color: isSelected
                ? project.color.withValues(alpha: 0.12)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Text(project.emoji, style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  project.title,
                  style: textTheme.titleMedium?.copyWith(
                    color: isSelected ? project.color : colors.textPrimary,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
              if (count != null) ...[
                const SizedBox(width: 8),
                Text(
                  '$count',
                  style: textTheme.bodySmall?.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
