import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/theme/theme_extensions.dart';
import 'package:frontend/features/notes/domain/entities/note.dart';
import 'package:frontend/features/notes/domain/task_priority.dart';
import 'package:frontend/features/notes/presentation/helpers.dart';
import 'package:frontend/features/notes/presentation/notifiers/notes_notifier.dart';
import 'package:frontend/features/notes/presentation/notifiers/ui_state.dart';
import 'package:frontend/i18n/strings.g.dart';

class SwipableTaskCard extends ConsumerWidget {
  const SwipableTaskCard({
    required this.note,
    required this.listName,
    required this.onTap,
    super.key,
  });

  final Note note;
  final String listName;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showDescription = ref.watch(showDescriptionProvider);

    return Dismissible(
      key: ValueKey('cal-task-${note.id}'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: context.colorScheme.onError,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(
          Icons.delete_outline,
          color: context.colorScheme.error,
          size: 24,
        ),
      ),
      confirmDismiss: (_) => confirmDeletion(
        context,
        context.t.home.deleteTask,
        context.t.home.deleteTaskMessage,
      ),
      onDismissed: (_) => ref.read(notesProvider.notifier).deleteNote(note),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: context.isLight
                ? context.colorScheme.surface
                : context.colorScheme.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: context.colorScheme.outlineVariant),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 2,
            ),
            horizontalTitleGap: 8,
            leading: SizedBox(
              width: 24,
              height: 24,
              child: Checkbox(
                value: note.isCompleted,
                onChanged: (_) =>
                    ref.read(notesProvider.notifier).toggleNote(note),
                activeColor: context.colorScheme.primary,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                side: BorderSide(
                  color: context.colorScheme.primary,
                  width: 1.5,
                ),
              ),
            ),
            title: Row(
              children: [
                // Індикатор пріоритету
                if (note.priority != TaskPriority.none) ...[
                  Icon(Icons.flag, size: 12, color: note.priority.color),
                  const SizedBox(width: 4),
                ],
                Expanded(
                  child: Text(note.title, style: context.textTheme.titleMedium),
                ),
              ],
            ),
            subtitle: showDescription && note.subtitle.isNotEmpty
                ? Text(
                    note.subtitle,
                    style: context.textTheme.bodySmall?.copyWith(
                      color: context.theme.hintColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  )
                : null,
            trailing: (listName.isNotEmpty || note.dueTime != null)
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (note.dueTime != null)
                        Text(
                          '${note.dueTime!.hour.toString().padLeft(2, '0')}:'
                          '${note.dueTime!.minute.toString().padLeft(2, '0')}',
                          style: context.textTheme.bodySmall?.copyWith(
                            color: context.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      if (listName.isNotEmpty)
                        Text(listName, style: context.textTheme.bodySmall),
                    ],
                  )
                : null,
          ),
        ),
      ),
    );
  }
}
