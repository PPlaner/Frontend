import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/theme/theme_extensions.dart';
import 'package:frontend/features/notes/domain/entities/note.dart';
import 'package:frontend/features/notes/presentation/helpers.dart';
import 'package:frontend/features/notes/presentation/notifiers/notes_notifier.dart';
import 'package:frontend/i18n/strings.g.dart';

class SwipableCardWrapper extends ConsumerWidget {
  const SwipableCardWrapper({
    required this.note,
    required this.child,
    super.key,
  });

  final Note note;
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dismissible(
      key: ValueKey(
        'dismissable-${note.isCompleted ? 'completed-' : ''}note-${note.id}',
      ),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: context.colorScheme.onError,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(
          Icons.delete_outline,
          size: 24,
          color: context.colorScheme.error,
        ),
      ),
      confirmDismiss: (_) => confirmDeletion(
        context,
        context.t.home.deleteTask,
        context.t.home.deleteTaskMessage,
      ),
      onDismissed: (_) => ref.read(notesProvider.notifier).deleteNote(note),
      child: child,
    );
  }
}
