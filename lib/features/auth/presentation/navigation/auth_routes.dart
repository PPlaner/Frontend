import 'dart:async';

import 'package:flutter/material.dart';
import 'package:frontend/features/auth/presentation/screens/email_verification_screen.dart';
import 'package:frontend/features/auth/presentation/screens/login_screen.dart';
import 'package:frontend/features/auth/presentation/screens/register_screen.dart';
import 'package:go_router/go_router.dart';

part 'auth_routes.g.dart';

@TypedGoRoute<AuthRoute>(
  path: '/auth',
  routes: [
    TypedGoRoute<LoginRoute>(path: 'login'),
    TypedGoRoute<RegisterRoute>(path: 'register'),
    TypedGoRoute<EmailVerificationRoute>(path: 'email-verification'),
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
  const LoginRoute({this.source = 'onboarding'});

  final String source;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return LoginScreen(source: source);
  }
}

class RegisterRoute extends GoRouteData with $RegisterRoute {
  const RegisterRoute({this.source = 'onboarding'});

  final String source;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return RegisterScreen(source: source);
  }
}

class EmailVerificationRoute extends GoRouteData with $EmailVerificationRoute {
  const EmailVerificationRoute({this.source = 'onboarding'});

  final String source;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return EmailVerificationScreen(source: source);
  }
}
