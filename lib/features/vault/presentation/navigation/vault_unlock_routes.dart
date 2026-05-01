import 'package:flutter/material.dart';
import 'package:frontend/features/vault/presentation/screens/unlock_method_screen.dart';
import 'package:frontend/features/vault/presentation/screens/unlock_pattern_screen.dart';
import 'package:frontend/features/vault/presentation/screens/unlock_pin_screen.dart';
import 'package:frontend/features/vault/presentation/screens/unlock_recovery_screen.dart';
import 'package:go_router/go_router.dart';

part 'vault_unlock_routes.g.dart';

@TypedGoRoute<UnlockVaultRoute>(
  path: '/unlock',
  routes: [
    TypedGoRoute<UnlockPinRoute>(path: 'pin'),
    TypedGoRoute<UnlockPatternRoute>(path: 'pattern'),
    TypedGoRoute<UnlockRecoveryRoute>(path: 'recovery'),
  ],
)
class UnlockVaultRoute extends GoRouteData with $UnlockVaultRoute {
  const UnlockVaultRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const UnlockMethodScreen();
  }
}

class UnlockPinRoute extends GoRouteData with $UnlockPinRoute {
  const UnlockPinRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const UnlockPinScreen();
  }
}

class UnlockPatternRoute extends GoRouteData with $UnlockPatternRoute {
  const UnlockPatternRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const UnlockPatternScreen();
  }
}

class UnlockRecoveryRoute extends GoRouteData with $UnlockRecoveryRoute {
  const UnlockRecoveryRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const UnlockRecoveryScreen();
  }
}
