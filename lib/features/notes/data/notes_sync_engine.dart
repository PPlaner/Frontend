import 'package:frontend/core/domain/result.dart';
import 'package:frontend/core/services/sync/sync_types.dart';
import 'package:frontend/features/notes/data/dto/note_dto.dart';
import 'package:frontend/features/notes/domain/failures/notes_failure.dart';

abstract interface class NotesSyncEngine {
  Future<Result<List<NoteDto>, NotesFailure>> getPendingNotes();

  Future<Result<void, NotesFailure>> acknowledgePushedNotes(
    List<SyncAcknowledgement> acknowledgements,
  );

  Future<Result<void, NotesFailure>> applyRemoteNotes(
    List<NoteDto> remoteData,
  );
}
