import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frontend/features/vault/data/secure_vault_service.dart';
import 'package:frontend/features/vault/domain/entities/key_type.dart';
import 'package:frontend/features/vault/domain/failures/vault_failure.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'vault_setup_notifier.g.dart';
part 'vault_setup_notifier.freezed.dart';

@freezed
sealed class VaultSetupData with _$VaultSetupData {
  const factory VaultSetupData({
    required List<String> generatedRecoveryPhrase,

    KeyType? selectedType,
    String? temporarySecret,

    @Default(false) bool isSubmitting,
    VaultFailure? failure,
  }) = _VaultSetupData;
}

@Riverpod(keepAlive: true)
class VaultSetup extends _$VaultSetup {
  @override
  VaultSetupData build() => VaultSetupData(
    generatedRecoveryPhrase: List<String>.filled(12, 'apple'),
  );

  void setupPin(String secret) => state = state.copyWith(
    selectedType: KeyType.pin,
    temporarySecret: secret,
    failure: null,
  );

  Future<void> commitSetup() async {
    final type = state.selectedType;
    final secret = state.temporarySecret;
    final recoveryPhrase = state.generatedRecoveryPhrase;

    if (type == null || secret == null || state.isSubmitting) {
      return;
    }

    state = state.copyWith(isSubmitting: true, failure: null);

    final recoveryString = recoveryPhrase.join();
    final secrets = {type: secret, KeyType.recoveryPhrase: recoveryString};

    final result = await ref
        .read(vaultServiceProvider)
        .intializeNewVault(secrets);

    result.fold(
      (success) {
        state = state.copyWith(isSubmitting: false);
        // ref.read(vaultProvider.notifier).markAsUnlocked();
        ref.invalidateSelf();
      },
      (failure) {
        state = state.copyWith(isSubmitting: false, failure: failure);
      },
    );
  }
}
