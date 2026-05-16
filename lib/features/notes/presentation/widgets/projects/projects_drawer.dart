import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/theme/theme_extensions.dart';
import 'package:frontend/features/notes/domain/constants.dart';
import 'package:frontend/features/notes/presentation/notifiers/projects_notifier.dart';
import 'package:frontend/features/notes/presentation/widgets/projects/create_project_sheet.dart';
import 'package:frontend/features/notes/presentation/widgets/projects/drawer_project_item.dart';
import 'package:frontend/features/notes/presentation/widgets/projects/drawer_virtual_project_item.dart';
import 'package:frontend/i18n/strings.g.dart';

class ProjectsDrawer extends ConsumerWidget {
  const ProjectsDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lists = ref.watch(projectsProvider).value ?? [];

    final t = context.t;

    return Container(
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainer,
        borderRadius: const BorderRadius.horizontal(right: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(4, 0),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
              child: Text(t.home.myLists, style: context.textTheme.titleLarge),
            ),
            const SizedBox(height: 8),

            DrawerVirtualProjectItem(
              id: todayProjectId,
              count: null,
              title: t.home.today,
              emoji: '📅',
              color: context.colorScheme.primary,
            ),

            DrawerVirtualProjectItem(
              id: inboxProjectId,
              count: null,
              title: t.home.inbox,
              emoji: '📥',
              color: context.colorScheme.primary,
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Divider(height: 1, color: context.theme.dividerColor),
            ),

            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: lists.length,
                itemBuilder: (_, i) {
                  return DrawerProjectItem(project: lists[i], count: null);
                },
              ),
            ),

            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Divider(height: 1, color: context.theme.dividerColor),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 4, 12, 16),
              child: TextButton.icon(
                onPressed: () => showModalBottomSheet<void>(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => const CreateProjectSheet(),
                ),
                icon: const Icon(Icons.add_box_outlined, size: 20),
                label: Text(t.home.addList),
                style: TextButton.styleFrom(
                  foregroundColor: context.colorScheme.primary,
                  textStyle: context.textTheme.titleMedium?.copyWith(
                    color: context.colorScheme.primary,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
