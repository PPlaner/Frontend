import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'access_token.g.dart';

@Riverpod(keepAlive: true)
class AccessToken extends _$AccessToken {
  @override
  String? build() => null;

  // Using a method preserves an explicit,
  // action-based API for state transitions in Riverpod.
  // ignore: use_setters_to_change_properties
  void setToken(String token) => state = token;
  void removeToken() => state = null;
}
