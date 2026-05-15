import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/features/notes/domain/entities/note.dart';
import 'package:frontend/features/notes/domain/task_priority.dart';
import 'package:frontend/features/notes/presentation/helpers.dart';
import 'package:frontend/features/notes/presentation/notifiers/notes_notifier.dart';
import 'package:frontend/features/notes/presentation/notifiers/ui_state.dart';
import 'package:frontend/i18n/strings.g.dart';

class SwipableTaskCard extends ConsumerWidget {
  const SwipableTaskCard({
    required this.note,
    required this.onTap,
    super.key,
  });

  final Note note;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showDescription = ref.watch(showDescriptionProvider);

    final textTheme = Theme.of(context).textTheme;
    final colors = AppColors.of(context);

    return Dismissible(
      key: ValueKey('dismissible-${note.id}'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: AppColors.deleteBackground,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Icon(
          Icons.delete_outline,
          color: AppColors.error,
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
            color: colors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: colors.cardBorder),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                // Чекбокс — окремий від тапу на картку
                SizedBox(
                  width: 24,
                  height: 24,
                  child: Checkbox(
                    value: note.isCompleted,
                    onChanged: (_) =>
                        ref.read(notesProvider.notifier).toggleNote(note),
                    activeColor: AppColors.primary,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    side: const BorderSide(
                      color: AppColors.primary,
                      width: 1.5,
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // Назва + підзаголовок
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          // Індикатор пріоритету
                          if (note.priority != TaskPriority.none) ...[
                            Icon(
                              Icons.flag,
                              size: 12,
                              color: note.priority.color,
                            ),
                            const SizedBox(width: 4),
                          ],
                          Expanded(
                            child: Text(
                              note.title,
                              style: textTheme.titleMedium,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      if (showDescription && note.subtitle.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          extractPlainText(note.subtitle),
                          style: textTheme.bodySmall?.copyWith(
                            color: colors.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                // Час/дата — як на сторінці календаря
                Text(
                  note.timeLabel(context.t),
                  style: textTheme.bodySmall?.copyWith(
                    color: note.dueTime != null
                        ? AppColors.primary
                        : colors.textSecondary,
                    fontWeight: note.dueTime != null
                        ? FontWeight.w600
                        : FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
