import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/theme/theme_extensions.dart';
import 'package:frontend/features/notes/domain/entities/note.dart';
import 'package:frontend/features/notes/presentation/helpers.dart';
import 'package:frontend/features/notes/presentation/notifiers/notes_notifier.dart';
import 'package:frontend/features/notes/presentation/notifiers/ui_state.dart';
import 'package:frontend/i18n/strings.g.dart';

class SwipableCompletedTile extends ConsumerWidget {
  const SwipableCompletedTile({
    required this.note,
    required this.onTap,
    super.key,
  });

  final Note note;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showDescription = ref.watch(showDescriptionProvider);

    return Dismissible(
      key: ValueKey('dismissible-completed-${note.id}'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: context.colorScheme.onError,
          borderRadius: BorderRadius.circular(12),
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
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () =>
                        ref.read(notesProvider.notifier).toggleNote(note),
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: context.colorScheme.primary,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Icon(
                        Icons.check,
                        size: 14,
                        color: context.colorScheme.surface,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      note.title,
                      style: context.textTheme.titleMedium?.copyWith(
                        decoration: TextDecoration.lineThrough,
                        color: context.theme.hintColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),

                  Text(
                    note.timeLabel(context.t),
                    style: context.textTheme.bodySmall?.copyWith(
                      color: context.theme.hintColor,
                    ),
                  ),
                ],
              ),
              if (showDescription && note.subtitle.isNotEmpty) ...[
                const SizedBox(height: 2),
                Padding(
                  padding: const EdgeInsets.only(left: 32),
                  child: Text(
                    note.subtitle,
                    style: context.textTheme.bodySmall?.copyWith(
                      color: context.theme.hintColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
