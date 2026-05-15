import 'package:frontend/features/notes/domain/constants.dart';
import 'package:frontend/features/notes/domain/entities/note.dart';
import 'package:frontend/features/notes/presentation/notifiers/notes_notifier.dart';
import 'package:frontend/features/notes/presentation/notifiers/ui_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'filtered_notes_provider.g.dart';

@riverpod
List<Note> projectNotes(Ref ref) {
  final allNotesAsync = ref.watch(notesProvider);
  final selectedProjectId = ref.watch(selectedProjectIdProvider);

  final allNotes = allNotesAsync.value ?? [];

  if (selectedProjectId == todayProjectId) {
    final now = DateTime.now();
    return allNotes.where((note) {
      if (note.dueDate == null) return false;

      return note.dueDate!.year == now.year &&
          note.dueDate!.month == now.month &&
          note.dueDate!.day == now.day;
    }).toList();
  }

  if (selectedProjectId == inboxProjectId) {
    return allNotes
        .where((note) => note.dueDate != null || note.dueTime != null)
        .toList();
  }

  return allNotes.where((note) => note.projectId == selectedProjectId).toList();
}
