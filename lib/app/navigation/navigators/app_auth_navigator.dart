import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/app/navigation/app_router.dart';
import 'package:frontend/features/auth/presentation/navigation/auth_navigator.dart';
import 'package:frontend/features/notes/presentation/navigation/notes_routes.dart';
import 'package:frontend/features/vault/presentation/navigation/vault_unlock_routes.dart';
import 'package:frontend/features/vault/presentation/notifiers/vault_notifier.dart';

class AppAuthNavigator implements AuthNavigator {
  const AppAuthNavigator(this.ref);

  final Ref ref;

  @override
  void onOnboardingLoginCompleted() {
    ref.read(appRouterProvider).go(const UnlockVaultRoute().location);
  }

  @override
  void onAuthCompleted() {
    ref.read(vaultProvider.notifier).forcePushKeys();
    ref.read(appRouterProvider).go(const NotesRoute().location);
  }
}
