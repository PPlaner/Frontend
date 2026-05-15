import 'package:frontend/app/database/database.dart';
import 'package:frontend/app/database/database_provider.dart';
import 'package:frontend/core/sync/sync_types.dart';
import 'package:frontend/features/notes/data/daos/notes_dao.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notes_local_data_source.g.dart';

class NotesLocalDataSource {
  NotesLocalDataSource({required NotesDao notesDao}) : _notesDao = notesDao;

  final NotesDao _notesDao;

  Future<NoteModel> create(NotesCompanion note) => _notesDao.insertNote(note);

  Future<void> save(NotesCompanion note) => _notesDao.updateNote(note);

  Future<void> saveWithConflict(
    NotesCompanion note,
    NoteConflictsCompanion conflict,
  ) => _notesDao.updateWithConflict(note, conflict);

  Future<void> acknowledgePushed(
    List<SyncAcknowledgement> acknowledgements,
  ) => _notesDao.acknowledgePushed(acknowledgements);

  Future<NoteModel?> get(String id) => _notesDao.getNote(id);

  Future<List<NoteModel>> getAll() => _notesDao.getAllNotes();

  Future<List<NoteModel>> getPending() => _notesDao.getPending();

  Future<void> delete(String id) => _notesDao.deleteNote(id);
}

@riverpod
NotesLocalDataSource notesLocalDataSource(Ref ref) =>
    NotesLocalDataSource(notesDao: ref.watch(appDatabaseProvider).notesDao);
