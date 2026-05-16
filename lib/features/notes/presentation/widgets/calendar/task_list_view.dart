import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/theme/theme_extensions.dart';
import 'package:frontend/features/notes/domain/constants.dart';
import 'package:frontend/features/notes/domain/entities/project.dart';
import 'package:frontend/features/notes/presentation/notifiers/projects_notifier.dart';
import 'package:frontend/features/notes/presentation/notifiers/providers/calendar_notes_provider.dart';
import 'package:frontend/features/notes/presentation/screens/task_detail_bottom_sheet.dart';
import 'package:frontend/features/notes/presentation/widgets/notes/active_note_card.dart';
import 'package:frontend/features/notes/presentation/widgets/notes/completed_note_card.dart';
import 'package:frontend/features/notes/presentation/widgets/notes/completed_secion.dart';
import 'package:frontend/i18n/strings.g.dart';

class TaskListView extends ConsumerWidget {
  const TaskListView({super.key});

  String _listNameFor(List<Project> allProjects, String projectId) {
    return allProjects.where((p) => p.id == projectId).firstOrNull?.title ??
        t.home.inbox;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allProjects = ref.watch(projectsProvider).value ?? [];
    final activeNotes = ref.watch(activeCalendarNotesProvider);
    final completedNotes = ref.watch(completedCalendarNotesProvider);

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
      children: [
        ...activeNotes.map(
          (task) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: ActiveNoteCard(
              key: ValueKey(task.id),
              note: task,
              projectName: _listNameFor(
                allProjects,
                task.projectId ?? inboxProjectId,
              ),
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

        if (completedNotes.isNotEmpty) ...[
          const SizedBox(height: 4),
          CompletedSection(
            children: completedNotes
                .map(
                  (note) => CompletedNoteCard(
                    key: ValueKey(note.id),
                    note: note,
                    projectName: _listNameFor(
                      allProjects,
                      note.projectId ?? inboxProjectId,
                    ),
                    onTap: () => showModalBottomSheet<void>(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      barrierColor: Colors.black.withValues(alpha: 0.15),
                      builder: (_) => TaskDetailBottomSheet(
                        note: note,
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
