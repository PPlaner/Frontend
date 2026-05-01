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
    final hasMasterKey = ref.watch(isMasterKeyPresentProvider);

    if (hasMasterKey) return const VaultUnlocked();

    unawaited(_checkIntitalizationState());
    return const VaultInitializing();
  }

  void markAsUnlocked() => state = const VaultUnlocked();

  void lockVault() {
    ref.read(sessionControllerProvider).clearSession();
    state = const VaultLocked();
  }

  Future<void> _checkIntitalizationState() async {
    final vaultService = ref.read(vaultServiceProvider);
    final result = await vaultService.isInitialized();

    state = result.fold(
      (isInit) => isInit ? const VaultLocked() : const VaultNotInitialized(),
      VaultError.new,
    );
  }
}
