// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cookie_jar.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(cookieJar)
final cookieJarProvider = CookieJarProvider._();

final class CookieJarProvider
    extends
        $FunctionalProvider<
          PersistCookieJar,
          PersistCookieJar,
          PersistCookieJar
        >
    with $Provider<PersistCookieJar> {
  CookieJarProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cookieJarProvider',
        isAutoDispose: false,
        dependencies: <ProviderOrFamily>[],
        $allTransitiveDependencies: <ProviderOrFamily>[],
      );

  @override
  String debugGetCreateSourceHash() => _$cookieJarHash();

  @$internal
  @override
  $ProviderElement<PersistCookieJar> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PersistCookieJar create(Ref ref) {
    return cookieJar(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PersistCookieJar value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PersistCookieJar>(value),
    );
  }
}

String _$cookieJarHash() => r'2775660dceea5114083220479dd0b18d2276d605';
