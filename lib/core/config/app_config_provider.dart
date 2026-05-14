import 'package:frontend/core/config/app_config.dart';
import 'package:frontend/core/config/env_config.dart' as env;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_config_provider.g.dart';

@Riverpod(keepAlive: true)
AppConfig appConfig(Ref ref) =>
    const AppConfig(apiUrl: env.apiUrl, environment: env.environmentName);
