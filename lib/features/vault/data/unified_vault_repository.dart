import 'package:frontend/core/domain/result.dart';
import 'package:frontend/core/utils/data_source_runner.dart';
import 'package:frontend/features/vault/data/mappers/key_slot_local_mapper.dart';
import 'package:frontend/features/vault/data/sources/vault_local_data_source.dart';
import 'package:frontend/features/vault/domain/entities/key_slot.dart';
import 'package:frontend/features/vault/domain/entities/key_type.dart';
import 'package:frontend/features/vault/domain/failures/vault_failure.dart';
import 'package:frontend/features/vault/domain/vault_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'unified_vault_repository.g.dart';

class UnifiedVaultRepository with DataSourceRunner implements VaultRepository {
  UnifiedVaultRepository({
    required VaultLocalDataSource local,
  }) : _local = local;

  final VaultLocalDataSource _local;

  @override
  Future<Result<void, VaultFailure>> saveKeySlot(KeySlot slot) async {
    return localRunner(
      call: () => _local.saveKeySlot(slot.toCompanion()),
      mapCore: VaultFailure.core,
    );
  }

  @override
  Future<Result<void, VaultFailure>> saveKeySlots(List<KeySlot> slots) async {
    final companions = slots.map((s) => s.toCompanion()).toList();

    return localRunner(
      call: () => _local.saveKeySlots(companions),
      mapCore: VaultFailure.core,
    );
  }

  @override
  Future<Result<List<KeySlot>, VaultFailure>> getAll() async {
    final result = await localRunner(
      call: _local.getAll,
      mapCore: VaultFailure.core,
    );

    return result.map(
      (models) => models.map((model) => model.toDomain()).toList(),
    );
  }

  @override
  Future<Result<KeySlot?, VaultFailure>> getKeySlotByType(KeyType type) async {
    final result = await localRunner(
      call: () => _local.getKeySlotByType(type),
      mapCore: VaultFailure.core,
    );

    return result.map((model) => model?.toDomain());
  }
}

@Riverpod(keepAlive: true)
VaultRepository vaultRepository(Ref ref) =>
    UnifiedVaultRepository(local: ref.watch(vaultLocalDataSourceProvider));
