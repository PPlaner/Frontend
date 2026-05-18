import 'package:frontend/features/notes/domain/entities/note.dart';
import 'package:frontend/features/notes/presentation/notifiers/notes_notifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'note_by_id.g.dart';

@riverpod
Note? noteById(Ref ref, String id) {
  final notes = ref.watch(notesProvider).value ?? {};

  return notes.values.where((note) => note.id == id).firstOrNull;
}
