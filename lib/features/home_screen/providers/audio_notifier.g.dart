// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audio_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AudioNotifier)
const audioProvider = AudioNotifierProvider._();

final class AudioNotifierProvider
    extends $NotifierProvider<AudioNotifier, AsyncValue<String?>> {
  const AudioNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'audioProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$audioNotifierHash();

  @$internal
  @override
  AudioNotifier create() => AudioNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<String?> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<String?>>(value),
    );
  }
}

String _$audioNotifierHash() => r'e16c57a1d07adca2f33ffd3995b0b0ba8de22bb2';

abstract class _$AudioNotifier extends $Notifier<AsyncValue<String?>> {
  AsyncValue<String?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<String?>, AsyncValue<String?>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<String?>, AsyncValue<String?>>,
              AsyncValue<String?>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
