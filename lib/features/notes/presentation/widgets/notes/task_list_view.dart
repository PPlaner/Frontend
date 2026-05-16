import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/theme/theme_extensions.dart';
import 'package:frontend/features/notes/presentation/notifiers/providers/active_notes_provider.dart';
import 'package:frontend/features/notes/presentation/notifiers/providers/completed_notes_provider.dart';
import 'package:frontend/features/notes/presentation/screens/task_detail_bottom_sheet.dart';
import 'package:frontend/features/notes/presentation/widgets/notes/active_note_card.dart';
import 'package:frontend/features/notes/presentation/widgets/notes/completed_note_card.dart';
import 'package:frontend/features/notes/presentation/widgets/notes/completed_secion.dart';

class TaskListView extends ConsumerWidget {
  const TaskListView({
    required this.title,
    super.key,
  });

  final String? title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeTasks = ref.watch(activeNotesProvider);
    final completedTasks = ref.watch(completedNotesProvider);

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 100),
      children: [
        if (title != null) Text(title!, style: context.textTheme.displayLarge),
        if (title != null) const SizedBox(height: 16),

        ...activeTasks.map(
          (task) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: ActiveNoteCard(
              key: ValueKey(task.id),
              note: task,
              onTap: () => showModalBottomSheet<void>(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                barrierColor: context.colorScheme.shadow.withValues(
                  alpha: 0.1,
                ),
                builder: (_) => TaskDetailBottomSheet(
                  note: task,
                ),
              ),
            ),
          ),
        ),

        if (completedTasks.isNotEmpty) ...[
          const SizedBox(height: 4),
          CompletedSection(
            children: completedTasks
                .map(
                  (task) => CompletedNoteCard(
                    key: ValueKey(task.id),
                    note: task,
                    onTap: () => showModalBottomSheet<void>(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      barrierColor: context.colorScheme.shadow.withValues(
                        alpha: 0.1,
                      ),
                      builder: (_) => TaskDetailBottomSheet(
                        note: task,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ],
    );
  }
}
