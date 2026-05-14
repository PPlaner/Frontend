import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:frontend/core/config/app_config_provider.dart';
import 'package:frontend/core/constants/app_timeouts.dart' as timeouts;
import 'package:frontend/core/network/interceptors/auth_interceptor.dart';
import 'package:frontend/core/network/token_refresher.dart';
import 'package:frontend/core/storage/cookie_jar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dio_provider.g.dart';

@Riverpod(keepAlive: true)
TokenRefresher tokenRefresher(Ref ref) =>
    throw UnimplementedError('tokenRefresher must be overriden in main');

@Riverpod(keepAlive: true)
Dio dio(Ref ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: ref.read(appConfigProvider).apiUrl,
      connectTimeout: timeouts.networkRequest,
      receiveTimeout: timeouts.networkRequest,
      sendTimeout: timeouts.networkRequest,
      contentType: Headers.jsonContentType,
    ),
  );

  dio.interceptors.addAll([
    CookieManager(ref.watch(cookieJarProvider)),
    AuthInterceptor(ref),
    if (kDebugMode) LogInterceptor(requestBody: true, responseBody: true),
  ]);

  return dio;
}

@Riverpod(keepAlive: true)
Dio refreshDio(Ref ref) {
  final refreshDio = Dio(
    BaseOptions(
      baseUrl: ref.read(appConfigProvider).apiUrl,
      connectTimeout: timeouts.networkRequest,
      receiveTimeout: timeouts.networkRequest,
      sendTimeout: timeouts.networkRequest,
      contentType: Headers.jsonContentType,
    ),
  );

  refreshDio.interceptors.add(CookieManager(ref.watch(cookieJarProvider)));

  return refreshDio;
}
