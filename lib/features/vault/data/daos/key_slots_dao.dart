import 'package:drift/drift.dart';
import 'package:frontend/app/database/database.dart';
import 'package:frontend/core/sync/sync_status.dart';
import 'package:frontend/features/vault/data/tables/key_slots.dart';
import 'package:frontend/features/vault/domain/entities/key_type.dart';

part 'key_slots_dao.g.dart';

@DriftAccessor(tables: [KeySlots])
class KeySlotsDao extends DatabaseAccessor<AppDatabase>
    with _$KeySlotsDaoMixin {
  KeySlotsDao(super.attachedDatabase);

  Future<void> saveKeySlot(KeySlotsCompanion slot) =>
      into(keySlots).insert(slot, mode: InsertMode.insertOrReplace);

  Future<void> saveKeySlots(List<KeySlotsCompanion> slots) => batch((batch) {
    batch.insertAll(keySlots, slots);
  });

  Future<List<KeySlotModel>> getAllKeySlots() => select(keySlots).get();

  Future<KeySlotModel?> getKeySlotByType(KeyType type) => (select(
    keySlots,
  )..where((tbl) => tbl.type.equals(type.index))).getSingleOrNull();

  Future<List<KeySlotModel>> getPendingKeySlots() => (select(
    keySlots,
  )..where((tbl) => tbl.syncStatus.equals(SyncStatus.modified.index))).get();

  Future<void> deleteKeySlot(KeyType type) => (delete(
    keySlots,
  )..where((tbl) => tbl.type.equals(type.index))).go();
}
