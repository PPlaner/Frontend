import 'package:frontend/core/services/sync/sync_status.dart';
import 'package:frontend/features/notes/data/dto/note_dto.dart';
import 'package:frontend/features/notes/domain/entities/encrypted_note.dart';

extension NoteDtoToEncrypted on NoteDto {
  EncryptedNote toDomain() => EncryptedNote(
    id: id,
    encryptedTitle: encryptedTitle,
    encryptedContent: encryptedContent,

    localVersion: version,
    lastSyncedVersion: version,
    syncStatus: SyncStatus.synced,

    createdAt: createdAt,
    updatedAt: updatedAt,
    deletedAt: deletedAt,

    projectId: projectId,
  );
}

extension EncryptedNoteToDto on EncryptedNote {
  NoteDto toDto() => NoteDto(
    id: id,
    encryptedTitle: encryptedTitle,
    encryptedContent: encryptedContent,

    version: lastSyncedVersion,

    createdAt: createdAt,
    updatedAt: updatedAt,
    deletedAt: deletedAt,

    projectId: projectId,
  );
}
