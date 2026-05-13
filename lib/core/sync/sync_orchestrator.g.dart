// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_orchestrator.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(registeredSyncables)
final registeredSyncablesProvider = RegisteredSyncablesProvider._();

final class RegisteredSyncablesProvider
    extends $FunctionalProvider<List<Syncable>, List<Syncable>, List<Syncable>>
    with $Provider<List<Syncable>> {
  RegisteredSyncablesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'registeredSyncablesProvider',
        isAutoDispose: false,
        dependencies: <ProviderOrFamily>[],
        $allTransitiveDependencies: <ProviderOrFamily>[],
      );

  @override
  String debugGetCreateSourceHash() => _$registeredSyncablesHash();

  @$internal
  @override
  $ProviderElement<List<Syncable>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<Syncable> create(Ref ref) {
    return registeredSyncables(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Syncable> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Syncable>>(value),
    );
  }
}

String _$registeredSyncablesHash() =>
    r'2e657285c7aa0d326aaf971f01c5957f405438c5';

@ProviderFor(SyncOrchestrator)
final syncOrchestratorProvider = SyncOrchestratorProvider._();

final class SyncOrchestratorProvider
    extends $NotifierProvider<SyncOrchestrator, SyncState> {
  SyncOrchestratorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'syncOrchestratorProvider',
        isAutoDispose: false,
        dependencies: <ProviderOrFamily>[registeredSyncablesProvider],
        $allTransitiveDependencies: <ProviderOrFamily>[
          SyncOrchestratorProvider.$allTransitiveDependencies0,
        ],
      );

  static final $allTransitiveDependencies0 = registeredSyncablesProvider;

  @override
  String debugGetCreateSourceHash() => _$syncOrchestratorHash();

  @$internal
  @override
  SyncOrchestrator create() => SyncOrchestrator();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SyncState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SyncState>(value),
    );
  }
}

String _$syncOrchestratorHash() => r'1f3b38b7e86e29dc520c9a3a5dfc76ce33ab6bcc';

abstract class _$SyncOrchestrator extends $Notifier<SyncState> {
  SyncState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<SyncState, SyncState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SyncState, SyncState>,
              SyncState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
