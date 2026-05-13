import 'package:frontend/core/domain/core_failure.dart';
import 'package:frontend/core/domain/result.dart';
import 'package:frontend/core/network/token_refresher.dart';
import 'package:frontend/core/utils/data_source_runner.dart';
import 'package:frontend/features/auth/data/dto/login_request_dto.dart';
import 'package:frontend/features/auth/data/dto/register_request_dto.dart';
import 'package:frontend/features/auth/data/dto/request_verification_dto.dart';
import 'package:frontend/features/auth/data/sources/auth_remote_data_source.dart';
import 'package:frontend/features/auth/domain/auth_repository.dart';
import 'package:frontend/features/auth/domain/failures/auth_failure.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'unified_auth_repository.g.dart';

class UnifiedAuthRepository
    with DataSourceRunner
    implements AuthRepository, TokenRefresher {
  UnifiedAuthRepository({required AuthRemoteDataSource remote})
    : _remote = remote;

  final AuthRemoteDataSource _remote;

  // --- Repository interface implementation ---

  @override
  Future<Result<String, AuthFailure>> login(
    String email,
    String password,
  ) async {
    final result = await remoteRunner(
      call: () =>
          _remote.login(LoginRequestDto(email: email, password: password)),
      mapCore: AuthFailure.core,
    );

    return result.map((dto) => dto.accessToken);
  }

  @override
  Future<Result<void, AuthFailure>> requestVerification(String email) {
    return remoteRunner(
      call: () =>
          _remote.requestVerification(RequestVerificationDto(email: email)),
      mapCore: AuthFailure.core,
    );
  }

  @override
  Future<Result<String, AuthFailure>> register(
    String email,
    String password,
    String code,
  ) async {
    final result = await remoteRunner(
      call: () => _remote.register(
        RegisterRequestDto(email: email, password: password, code: code),
      ),
      mapCore: AuthFailure.core,
    );

    return result.map((dto) => dto.accessToken);
  }

  // --- Token refresher interface implementation ---

  @override
  Future<Result<String, CoreFailure>> refreshToken() async {
    final result = await remoteRunner(
      call: _remote.refresh,
      mapCore: (core) => core,
    );

    return result.map((dto) => dto.accessToken);
  }
}

@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) =>
    ref.watch(unifiedAuthRepositoryProvider);

@Riverpod(keepAlive: true)
UnifiedAuthRepository unifiedAuthRepository(Ref ref) =>
    UnifiedAuthRepository(remote: ref.watch(authRemoteDataSourceProvider));
