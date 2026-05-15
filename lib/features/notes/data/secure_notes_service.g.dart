// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'secure_notes_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(notesService)
final notesServiceProvider = NotesServiceProvider._();

final class NotesServiceProvider
    extends $FunctionalProvider<NotesService, NotesService, NotesService>
    with $Provider<NotesService> {
  NotesServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notesServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notesServiceHash();

  @$internal
  @override
  $ProviderElement<NotesService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  NotesService create(Ref ref) {
    return notesService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NotesService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NotesService>(value),
    );
  }
}

String _$notesServiceHash() => r'01d1cc798ba7cad67f97a97c0eb2e3ce6ca434d5';
