import 'package:frontend/core/domain/result.dart';
import 'package:frontend/core/services/sync/sync_types.dart';
import 'package:frontend/features/notes/data/dto/project_dto.dart';
import 'package:frontend/features/notes/domain/failures/notes_failure.dart';

abstract interface class ProjectsSyncEngine {
  Future<Result<List<ProjectDto>, NotesFailure>> getPendingProjects();

  Future<Result<void, NotesFailure>> acknowledgePushedProjects(
    List<SyncAcknowledgement> acknowledgements,
  );

  Future<Result<void, NotesFailure>> applyRemoteProjects(
    List<ProjectDto> remoteData,
  );
}
