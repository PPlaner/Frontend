import 'package:frontend/core/services/sync/sync_status.dart';
import 'package:frontend/features/notes/data/dto/project_dto.dart';
import 'package:frontend/features/notes/domain/entities/encrypted_project.dart';

extension ProjectDtoToEncrypted on ProjectDto {
  EncryptedProject toDomain() => EncryptedProject(
    id: id,

    encryptedContent: encryptedContent,

    localVersion: version,
    lastSyncedVersion: version,
    syncStatus: SyncStatus.synced,

    createdAt: createdAt,
    updatedAt: updatedAt,
    deletedAt: deletedAt,
  );
}

extension EncryptedProjectToDto on EncryptedProject {
  ProjectDto toDto() => ProjectDto(
    id: id,

    encryptedContent: encryptedContent,

    version: lastSyncedVersion,

    createdAt: createdAt,
    updatedAt: updatedAt,
    deletedAt: deletedAt,
  );
}
