import 'package:frontend/core/domain/result.dart';
import 'package:frontend/core/sync/sync_status.dart';
import 'package:frontend/core/sync/sync_types.dart';
import 'package:frontend/core/utils/data_source_runner.dart';
import 'package:frontend/features/notes/data/dto/note_dto.dart';
import 'package:frontend/features/notes/data/dto/project_dto.dart';
import 'package:frontend/features/notes/data/mappers/encrypted_note_local_mapper.dart';
import 'package:frontend/features/notes/data/mappers/encrypted_note_remote_mapper.dart';
import 'package:frontend/features/notes/data/mappers/encrypted_project_local_mapper.dart';
import 'package:frontend/features/notes/data/mappers/encrypted_project_remote_mapper.dart';
import 'package:frontend/features/notes/data/notes_sync_engine.dart';
import 'package:frontend/features/notes/data/projects_sync_engine.dart';
import 'package:frontend/features/notes/data/sources/notes_local_data_source.dart';
import 'package:frontend/features/notes/data/sources/projects_local_data_source.dart';
import 'package:frontend/features/notes/domain/entities/encrypted_note.dart';
import 'package:frontend/features/notes/domain/failures/notes_failure.dart';
import 'package:frontend/features/notes/domain/notes_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'unified_notes_repository.g.dart';

class UnifiedNotesRepository
    with DataSourceRunner
    implements NotesRepository, NotesSyncEngine, ProjectsSyncEngine {
  UnifiedNotesRepository({
    required NotesLocalDataSource localNotes,
    required ProjectsLocalDataSource localProjects,
  }) : _localNotes = localNotes,
       _localProjects = localProjects;

  final NotesLocalDataSource _localNotes;
  final ProjectsLocalDataSource _localProjects;

  // --- Repository interface implementation ---

  @override
  Future<Result<void, NotesFailure>> saveNote(EncryptedNote note) async {
    return localRunner(
      call: () => _localNotes.create(note.toCompanion()),
      mapCore: NotesCoreFailure.new,
    );
  }

  @override
  Future<Result<EncryptedNote?, NotesFailure>> getNote(String id) async {
    final result = await localRunner(
      call: () => _localNotes.get(id),
      mapCore: NotesCoreFailure.new,
    );

    return result.map((model) => model?.toDomain());
  }

  // --- Notes sync engine interface implementation ---

  @override
  Future<Result<List<NoteDto>, NotesFailure>> getPendingNotes() async {
    final result = await localRunner(
      call: _localNotes.getPending,
      mapCore: NotesCoreFailure.new,
    );

    return result.map(
      (models) => models.map((model) => model.toDomain().toDto()).toList(),
    );
  }

  @override
  Future<Result<void, NotesFailure>> acknowledgePushedNotes(
    List<SyncAcknowledgement> acknowledgements,
  ) async {
    return localRunner(
      call: () => _localNotes.acknowledgePushed(acknowledgements),
      mapCore: NotesCoreFailure.new,
    );
  }

  @override
  Future<Result<void, NotesFailure>> applyRemoteNotes(
    List<NoteDto> remoteData,
  ) async {
    for (final dto in remoteData) {
      final processResult = await _processSingleNoteDelta(dto);

      if (processResult case Failure(error: final e)) return Failure(e);
    }

    return const Success(null);
  }

  // --- Projects sync engine interface implementation ---

  @override
  Future<Result<List<ProjectDto>, NotesFailure>> getPendingProjects() async {
    final result = await localRunner(
      call: _localProjects.getPending,
      mapCore: NotesCoreFailure.new,
    );

    return result.map(
      (models) => models.map((model) => model.toDomain().toDto()).toList(),
    );
  }

  @override
  Future<Result<void, NotesFailure>> acknowledgePushedProjects(
    List<SyncAcknowledgement> acknowledgements,
  ) async {
    return localRunner(
      call: () => _localProjects.acknowledgePushed(acknowledgements),
      mapCore: NotesCoreFailure.new,
    );
  }

  @override
  Future<Result<void, NotesFailure>> applyRemoteProjects(
    List<ProjectDto> remoteData,
  ) async {
    for (final dto in remoteData) {
      final processResult = await _processSingleProjectDelta(dto);

      if (processResult case Failure(error: final e)) return Failure(e);
    }

    return const Success(null);
  }

  // -- Sync engine logic ---

  Future<Result<void, NotesFailure>> _processSingleNoteDelta(
    NoteDto dto,
  ) async {
    final serverNote = dto.toDomain();

    final getResult = await localRunner(
      call: () => _localNotes.get(dto.id),
      mapCore: NotesCoreFailure.new,
    );

    if (getResult case Failure(error: final e)) return Failure(e);
    final noteModel = getResult.unwrap;

    // Note doesn't exist locally
    if (noteModel == null) {
      // Note doesn't exist on server either => skip
      if (dto.deletedAt != null) return const Success(null);

      return localRunner(
        call: () => _localNotes.create(serverNote.toCompanion()),
        mapCore: NotesCoreFailure.new,
      );
    }

    // Note has been modified locally and on the server
    if (noteModel.localVersion > noteModel.lastSyncedVersion) {
      return localRunner(
        call: () => _localNotes.saveWithConflict(
          noteModel
              .copyWith(syncStatus: SyncStatus.conflicted)
              .toCompanion(true),
          serverNote.toConflictCompanion(),
        ),
        mapCore: NotesCoreFailure.new,
      );
    }

    // Note hasn't been updated on the server
    if (dto.version <= noteModel.lastSyncedVersion) return const Success(null);

    // Note has been deleted on the server
    if (dto.deletedAt != null) {
      // Note has been modified locally and deleted on the server
      if (noteModel.localVersion > dto.version) {
        return localRunner(
          call: () => _localNotes.saveWithConflict(
            noteModel
                .copyWith(syncStatus: SyncStatus.conflicted)
                .toCompanion(true),
            serverNote.toConflictCompanion(),
          ),
          mapCore: NotesCoreFailure.new,
        );
      }

      return localRunner(
        call: () => _localNotes.delete(dto.id),
        mapCore: NotesCoreFailure.new,
      );
    }

    // No conflict => normal update
    return localRunner(
      call: () => _localNotes.save(serverNote.toCompanion()),
      mapCore: NotesCoreFailure.new,
    );
  }

  Future<Result<void, NotesFailure>> _processSingleProjectDelta(
    ProjectDto dto,
  ) async {
    final serverProject = dto.toDomain();

    final getResult = await localRunner(
      call: () => _localProjects.get(dto.id),
      mapCore: NotesCoreFailure.new,
    );

    if (getResult case Failure(error: final e)) return Failure(e);
    final projectModel = getResult.unwrap;

    // Project doesn't exist locally
    if (projectModel == null) {
      // Project doesn't exist on server either => skip
      if (serverProject.deletedAt != null) return const Success(null);

      return localRunner(
        call: () => _localProjects.create(serverProject.toCompanion()),
        mapCore: NotesCoreFailure.new,
      );
    }

    // LLW update
    if (serverProject.updatedAt.isAfter(projectModel.updatedAt)) {
      // Project has been deleted on the server => delete locally
      if (serverProject.deletedAt != null) {
        return localRunner(
          call: () => _localProjects.delete(projectModel.id),
          mapCore: NotesCoreFailure.new,
        );
      }

      return localRunner(
        call: () => _localProjects.save(
          serverProject.toCompanion(),
        ),
        mapCore: NotesCoreFailure.new,
      );
    }

    return const Success(null);
  }
}

@riverpod
NotesRepository notesRepository(Ref ref) =>
    ref.watch(unifiedNotesRepositoryProvider);

@riverpod
UnifiedNotesRepository unifiedNotesRepository(Ref ref) =>
    UnifiedNotesRepository(
      localNotes: ref.watch(notesLocalDataSourceProvider),
      localProjects: ref.watch(projectsLocalDataSourceProvider),
    );
