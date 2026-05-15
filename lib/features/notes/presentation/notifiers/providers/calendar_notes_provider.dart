import 'package:frontend/features/notes/domain/constants.dart';
import 'package:frontend/features/notes/domain/entities/note.dart';
import 'package:frontend/features/notes/presentation/notifiers/notes_notifier.dart';
import 'package:frontend/features/notes/presentation/notifiers/ui_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:table_calendar/table_calendar.dart';

part 'calendar_notes_provider.g.dart';

@riverpod
List<Note> calendarNotes(Ref ref) {
  final allNotesAsync = ref.watch(notesProvider);
  final selectedProjectId = ref.watch(selectedProjectIdProvider);
  final selectedDate = ref.watch(calendarSelectedDateProvider);

  final allNotes = allNotesAsync.value ?? [];

  return allNotes.where((note) {
    final isSameDate = isSameDay(note.dueDate, selectedDate);
    final matchesProject =
        selectedProjectId == allProjectsId ||
        note.projectId == selectedProjectId;

    return isSameDate && matchesProject;
  }).toList();
}

@riverpod
List<Note> activeCalendarNotes(Ref ref) {
  final notes = ref.watch(calendarNotesProvider);

  return notes.where((note) => !note.isCompleted).toList();
}

@riverpod
List<Note> completedCalendarNotes(Ref ref) {
  final notes = ref.watch(calendarNotesProvider);

  return notes.where((note) => note.isCompleted).toList();
}
