import 'package:frontend/core/domain/result.dart';
import 'package:frontend/features/auth/domain/failures/auth_failure.dart';

abstract interface class AuthService {
  Future<Result<void, AuthFailure>> login(String email, String password);
  Future<Result<void, AuthFailure>> register(String email, String password);
}
