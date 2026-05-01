import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frontend/features/vault/data/secure_vault_service.dart';
import 'package:frontend/features/vault/domain/entities/key_type.dart';
import 'package:frontend/features/vault/domain/failures/vault_failure.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'vault_unlock_notifier.g.dart';
part 'vault_unlock_notifier.freezed.dart';

@freezed
sealed class VaultUnlockData with _$VaultUnlockData {
  const factory VaultUnlockData({
    @Default(false) bool isUnlocking,
    VaultFailure? failure,
  }) = _VaultUnlockData;
}

@riverpod
class VaultUnlock extends _$VaultUnlock {
  @override
  VaultUnlockData build() => const VaultUnlockData();

  Future<void> unlockWithPin(String secret) async {
    if (state.isUnlocking) return;

    state = state.copyWith(isUnlocking: true, failure: null);

    final result = await ref
        .read(vaultServiceProvider)
        .unlock(KeyType.pin, secret);

    if (!ref.mounted) return;

    result.fold(
      (success) {
        state = state.copyWith(isUnlocking: false);
      },
      (failure) {
        state = state.copyWith(isUnlocking: false, failure: failure);
      },
    );
  }

  Future<void> unlockWithPhrase(List<String> secret) async {
    print('got');
    if (state.isUnlocking) return;

    state = state.copyWith(isUnlocking: true, failure: null);

    final result = await ref
        .read(vaultServiceProvider)
        .unlock(KeyType.recoveryPhrase, secret.join());

    if (!ref.mounted) return;

    result.fold(
      (success) {
        state = state.copyWith(isUnlocking: false);
      },
      (failure) {
        state = state.copyWith(isUnlocking: false, failure: failure);
      },
    );
  }
}
