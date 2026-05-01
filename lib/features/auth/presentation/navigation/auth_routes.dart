import 'dart:async';

import 'package:flutter/material.dart';
import 'package:frontend/features/auth/presentation/screens/login_screen.dart';
import 'package:frontend/features/auth/presentation/screens/register_screen.dart';
import 'package:go_router/go_router.dart';

part 'auth_routes.g.dart';

@TypedGoRoute<AuthRoute>(
  path: '/auth',
  routes: [
    TypedGoRoute<LoginRoute>(path: 'login'),
    TypedGoRoute<RegisterRoute>(path: 'register'),
  ],
)
class AuthRoute extends GoRouteData with $AuthRoute {
  const AuthRoute();

  @override
  String? redirect(BuildContext context, GoRouterState state) {
    final path = state.uri.path;

    if (path == '/auth' || path == '/auth/') {
      return const LoginRoute().location;
    }

    return null;
  }
}

class LoginRoute extends GoRouteData with $LoginRoute {
  const LoginRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const LoginScreen();
  }
}

class RegisterRoute extends GoRouteData with $RegisterRoute {
  const RegisterRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const RegisterScreen();
  }
}
