import 'package:frontend/core/domain/result.dart';
import 'package:frontend/features/auth/domain/failures/auth_failure.dart';

abstract interface class AuthRepository {
  Future<Result<String, AuthFailure>> login(String email, String password);
  Future<Result<String, AuthFailure>> register(String email, String password);
}
