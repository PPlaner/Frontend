import 'package:dio/dio.dart';
import 'package:frontend/core/network/api_endpoints.dart' as endpoints;
import 'package:frontend/core/network/dio_provider.dart';
import 'package:frontend/features/vault/data/dto/key_slot_dto.dart';
import 'package:frontend/features/vault/data/dto/key_slots_dto.dart';
import 'package:retrofit/retrofit.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'vault_remote_data_source.g.dart';

@RestApi()
abstract class VaultRemoteDataSource {
  factory VaultRemoteDataSource(Dio dio) = _VaultRemoteDataSource;

  @GET(endpoints.keySlots)
  Future<List<KeySlotDto>> getKeys();

  @PATCH(endpoints.keySlots)
  Future<void> pushKeys(@Body() KeySlotsDto keys);
}

@Riverpod(keepAlive: true)
VaultRemoteDataSource vaultRemoteDataSource(Ref ref) =>
    VaultRemoteDataSource(ref.watch(dioProvider));
