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

  if (selectedProjectId == todayProjectId) return allNotes;
  if (selectedProjectId == inboxProjectId) return allNotes;

  return allNotes.where((note) => note.projectId == selectedProjectId).toList();
}
