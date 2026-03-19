// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audio_service_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(audioService)
const audioServiceProvider = AudioServiceProvider._();

final class AudioServiceProvider
    extends $FunctionalProvider<AudioService, AudioService, AudioService>
    with $Provider<AudioService> {
  const AudioServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'audioServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$audioServiceHash();

  @$internal
  @override
  $ProviderElement<AudioService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AudioService create(Ref ref) {
    return audioService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AudioService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AudioService>(value),
    );
  }
}

String _$audioServiceHash() => r'48c52200e719db9f6005ed57002eac9787b41d91';

@ProviderFor(audioPosition)
const audioPositionProvider = AudioPositionProvider._();

final class AudioPositionProvider
    extends
        $FunctionalProvider<AsyncValue<Duration>, Duration, Stream<Duration>>
    with $FutureModifier<Duration>, $StreamProvider<Duration> {
  const AudioPositionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'audioPositionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$audioPositionHash();

  @$internal
  @override
  $StreamProviderElement<Duration> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<Duration> create(Ref ref) {
    return audioPosition(ref);
  }
}

String _$audioPositionHash() => r'9d0adb92d2544a3e474993d2162ac165ab9dca46';

@ProviderFor(audioPlayerState)
const audioPlayerStateProvider = AudioPlayerStateProvider._();

final class AudioPlayerStateProvider
    extends
        $FunctionalProvider<
          AsyncValue<PlayerState>,
          PlayerState,
          Stream<PlayerState>
        >
    with $FutureModifier<PlayerState>, $StreamProvider<PlayerState> {
  const AudioPlayerStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'audioPlayerStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$audioPlayerStateHash();

  @$internal
  @override
  $StreamProviderElement<PlayerState> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<PlayerState> create(Ref ref) {
    return audioPlayerState(ref);
  }
}

String _$audioPlayerStateHash() => r'1bd9b38e64ec02d940f50fb7a9d9ee9542c4e350';

@ProviderFor(audioDuration)
const audioDurationProvider = AudioDurationProvider._();

final class AudioDurationProvider
    extends
        $FunctionalProvider<AsyncValue<Duration?>, Duration?, Stream<Duration?>>
    with $FutureModifier<Duration?>, $StreamProvider<Duration?> {
  const AudioDurationProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'audioDurationProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$audioDurationHash();

  @$internal
  @override
  $StreamProviderElement<Duration?> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<Duration?> create(Ref ref) {
    return audioDuration(ref);
  }
}

String _$audioDurationHash() => r'4c31772a1955792cd63e5ce22b85229fff863922';
