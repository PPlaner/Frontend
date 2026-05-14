import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:frontend/core/config/user_config.dart';
import 'package:frontend/core/domain/core_failure.dart';
import 'package:frontend/core/domain/result.dart';
import 'package:frontend/core/sync/sync_status.dart';
import 'package:frontend/core/utils/data_source_runner.dart';
import 'package:frontend/features/vault/data/dto/key_slots_dto.dart';
import 'package:frontend/features/vault/data/mappers/key_slot_local_mapper.dart';
import 'package:frontend/features/vault/data/mappers/key_slot_remote_mapper.dart';
import 'package:frontend/features/vault/data/sources/vault_local_data_source.dart';
import 'package:frontend/features/vault/data/sources/vault_remote_data_source.dart';
import 'package:frontend/features/vault/domain/entities/key_slot.dart';
import 'package:frontend/features/vault/domain/entities/key_type.dart';
import 'package:frontend/features/vault/domain/failures/vault_failure.dart';
import 'package:frontend/features/vault/domain/vault_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'unified_vault_repository.g.dart';

class UnifiedVaultRepository with DataSourceRunner implements VaultRepository {
  UnifiedVaultRepository({
    required VaultLocalDataSource local,
    required VaultRemoteDataSource remote,
    required UserPreferences userPrefs,
  }) : _local = local,
       _remote = remote,
       _prefs = userPrefs;

  final VaultLocalDataSource _local;
  final VaultRemoteDataSource _remote;
  final UserPreferences _prefs;

  @override
  Future<Result<void, VaultFailure>> saveKeySlot(KeySlot slot) async {
    return localRunner(
      call: () => _local.saveKeySlot(slot.toCompanion()),
      mapCore: VaultCoreFailure.new,
    );
  }

  @override
  Future<Result<void, VaultFailure>> saveKeySlots(List<KeySlot> slots) async {
    final companions = slots.map((s) => s.toCompanion()).toList();

    return localRunner(
      call: () => _local.saveKeySlots(companions),
      mapCore: VaultCoreFailure.new,
    );
  }

  @override
  Future<Result<List<KeySlot>, VaultFailure>> getAll() async {
    if (_prefs.hasAuthenticatedBefore) {
      final connectivityResult = await Connectivity().checkConnectivity();

      if (connectivityResult.contains(ConnectivityResult.wifi)) {
        final syncResult = await syncKeys();
        if (syncResult case Failure(error: final e)) {
          switch (e) {
            case VaultCoreFailure(core: NetworkFailure()):
              break;
            default:
              return Failure(e);
          }
        }
      }
    }

    final result = await localRunner(
      call: _local.getAll,
      mapCore: VaultCoreFailure.new,
    );

    return result.map(
      (models) => models.map((model) => model.toDomain()).toList(),
    );
  }

  @override
  Future<Result<KeySlot?, VaultFailure>> getKeySlotByType(KeyType type) async {
    final result = await localRunner(
      call: () => _local.getKeySlotByType(type),
      mapCore: VaultCoreFailure.new,
    );

    return result.map((model) => model?.toDomain());
  }

  @override
  Future<Result<void, VaultFailure>> pushKeys() async {
    final result = await localRunner(
      call: _local.getAll,
      mapCore: VaultCoreFailure.new,
    );

    if (result case Failure(error: final e)) return Failure(e);
    final keys = result.unwrap;

    return remoteRunner(
      call: () => _remote.pushKeys(
        KeySlotsDto(keys: keys.map((m) => m.toDomain().toDto()).toList()),
      ),
      mapCore: VaultCoreFailure.new,
    );
  }

  @override
  Future<Result<void, VaultFailure>> syncKeys() async {
    final remoteResult = await remoteRunner(
      call: _remote.getKeys,
      mapCore: VaultCoreFailure.new,
    );

    if (remoteResult case Failure(error: final e)) return Failure(e);
    final remoteKeys = remoteResult.unwrap;

    // LWW update
    for (final remoteDto in remoteKeys) {
      final localModelResult = await localRunner(
        call: () => _local.getKeySlotByType(remoteDto.type),
        mapCore: VaultCoreFailure.new,
      );

      if (localModelResult case Failure(error: final e)) return Failure(e);
      final localModel = localModelResult.unwrap;

      if (localModel == null ||
          remoteDto.updatedAt.isAfter(localModel.updatedAt)) {
        await localRunner(
          call: () => _local.saveKeySlot(remoteDto.toDomain().toCompanion()),
          mapCore: VaultCoreFailure.new,
        );
      }
    }

    final pendingModelsResult = await localRunner(
      call: _local.getPending,
      mapCore: VaultCoreFailure.new,
    );

    if (pendingModelsResult case Failure(error: final e)) return Failure(e);
    final pendingModels = pendingModelsResult.unwrap;

    if (pendingModels.isNotEmpty) {
      final dtosToPush = pendingModels
          .map((m) => m.toDomain().toDto())
          .toList();

      final pushResult = await remoteRunner(
        call: () => _remote.pushKeys(KeySlotsDto(keys: dtosToPush)),
        mapCore: VaultCoreFailure.new,
      );

      if (pushResult is Success) {
        final toUpdate = pendingModels
            .map(
              (m) => m
                  .toDomain()
                  .copyWith(syncStatus: SyncStatus.synced)
                  .toCompanion(),
            )
            .toList();

        await localRunner(
          call: () => _local.saveKeySlots(toUpdate),
          mapCore: VaultCoreFailure.new,
        );
      }
    }

    return const Success(null);
  }
}

@Riverpod(keepAlive: true)
VaultRepository vaultRepository(Ref ref) => UnifiedVaultRepository(
  local: ref.watch(vaultLocalDataSourceProvider),
  remote: ref.watch(vaultRemoteDataSourceProvider),
  userPrefs: ref.watch(userPreferencesProvider),
);
