import 'package:drift/drift.dart';
import 'package:frontend/app/database/database.dart';
import 'package:frontend/features/vault/domain/entities/key_slot.dart';

extension KeySlotModelToDomain on KeySlotModel {
  KeySlot toDomain() => KeySlot(
    type: type,
    salt: salt,
    wrappedMasterKey: wrappedMasterKey,
    updatedAt: updatedAt,
    syncStatus: syncStatus,
  );
}

extension KeySlotToCompanion on KeySlot {
  KeySlotsCompanion toCompanion() => KeySlotsCompanion.insert(
    type: Value(type),
    salt: salt,
    wrappedMasterKey: wrappedMasterKey,
    updatedAt: Value(updatedAt),
    syncStatus: Value(syncStatus),
  );
}
