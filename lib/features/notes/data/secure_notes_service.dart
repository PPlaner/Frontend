import 'dart:convert';

import 'package:flutter_quill/flutter_quill.dart';
import 'package:frontend/core/crypto/crypto.dart';
import 'package:frontend/core/domain/core_failure.dart';
import 'package:frontend/core/domain/result.dart';
import 'package:frontend/core/session/crypto_session.dart';
import 'package:frontend/core/session/session_exceptions.dart';
import 'package:frontend/core/utils/logger.dart';
import 'package:frontend/features/notes/domain/entities/note.dart';
import 'package:frontend/features/notes/domain/failures/notes_failure.dart';
import 'package:frontend/features/notes/domain/mappers/notes_mapper.dart';
import 'package:frontend/features/notes/domain/notes_repository.dart';
import 'package:frontend/features/notes/domain/notes_service.dart';

class SecureNotesService implements NotesService {
  SecureNotesService({
    required EncryptionService encryption,
    required CryptoSession cryptoSession,
    required NotesRepository repository,
  }) : _encryption = encryption,
       _cryptoSession = cryptoSession,
       _repository = repository;

  final EncryptionService _encryption;
  final CryptoSession _cryptoSession;
  final NotesRepository _repository;

  @override
  Future<Result<void, NotesFailure>> saveNote(Note note) async {
    return _guard(() async {
      final masterKey = _cryptoSession.masterKey;

      final plainContent = jsonEncode(note.content.toDelta().toJson());

      final encryptedTitle = await _encryption.encryptString(
        note.title,
        masterKey,
      );
      final encryptedContent = await _encryption.encryptString(
        plainContent,
        masterKey,
      );

      final encryptedNote = note.toEncrypted(
        encryptedTitle: encryptedTitle,
        encryptedContent: encryptedContent,
      );

      return _repository.saveNote(encryptedNote);
    });
  }

  @override
  Future<Result<Note?, NotesFailure>> getNote(String id) async {
    return _guard(() async {
      final masterKey = _cryptoSession.masterKey;

      final encryptedNoteResult = await _repository.getNote(id);
      if (encryptedNoteResult case Failure(error: final e)) return Failure(e);

      final encryptedNote = encryptedNoteResult.unwrap;

      if (encryptedNote == null) {
        return const Failure(IdNotFound());
      }

      final title = await _encryption.decryptString(
        encryptedNote.encryptedTitle,
        masterKey,
      );
      final plainContent = await _encryption.decryptString(
        encryptedNote.encryptedContent,
        masterKey,
      );

      final content = Document.fromJson(
        jsonDecode(plainContent) as List<dynamic>,
      );

      final note = encryptedNote.toNote(title: title, content: content);

      return Success(note);
    });
  }

  Future<Result<T, NotesFailure>> _guard<T>(
    Future<Result<T, NotesFailure>> Function() action,
  ) async {
    try {
      return await action();
    } on SessionLockedException catch (_) {
      return const Failure(SessionLocked());
    } on CryptoException catch (e) {
      return Failure(NotesCoreFailure(CryptoFailure(e.message)));
    } on Exception catch (e, st) {
      logger.e('SecureNotesService operation failed', error: e, stackTrace: st);
      return Failure(NotesCoreFailure(UnexpectedFailure(e)));
    }
  }
}
