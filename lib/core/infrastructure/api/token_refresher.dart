import 'package:frontend/core/domain/core_failure.dart';
import 'package:frontend/core/domain/result.dart';

abstract interface class TokenRefresher {
  Future<Result<String, CoreFailure>> refreshToken();
}
