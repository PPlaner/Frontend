import 'dart:async';

import 'package:frontend/core/session/session_manager.dart';
import 'package:frontend/features/vault/data/secure_vault_service.dart';
import 'package:frontend/features/vault/domain/vault_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'vault_notifier.g.dart';

@Riverpod(keepAlive: true)
class VaultNotifier extends _$VaultNotifier {
  @override
  VaultState build() {
    final hasAccesssToken = ref.watch(isAccessTokenPresentProvider);
    final hasMasterKey = ref.watch(isMasterKeyPresentProvider);

    if (hasMasterKey) return const VaultUnlocked();

    unawaited(_checkIntitalizationState(hasAccesssToken));
    return const VaultInitializing();
  }

  Future<void> forcePushKeys() async {
    await ref.read(vaultServiceProvider).pushKeys();

    if (!ref.read(isMasterKeyPresentProvider)) {
      unawaited(
        _checkIntitalizationState(ref.read(isAccessTokenPresentProvider)),
      );
    }
  }

  Future<void> _checkIntitalizationState(bool hasAccesssToken) async {
    final vaultService = ref.read(vaultServiceProvider);
    final result = await vaultService.getUnlockMethods();

    if (ref.read(isMasterKeyPresentProvider)) return;

    state = result.fold(
      (keys) => keys.isNotEmpty
          ? VaultLocked(unlockMethods: keys)
          : hasAccesssToken
          ? const VaultFatal()
          : const VaultNotInitialized(),
      VaultError.new,
    );
  }
}
