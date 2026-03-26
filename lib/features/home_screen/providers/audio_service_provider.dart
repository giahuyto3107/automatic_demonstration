import 'package:automatic_demonstration/features/home_screen/data/services/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'audio_service_provider.g.dart';

@Riverpod(keepAlive: true)
AudioService audioService(Ref ref) {
  final service = AudioService();
  ref.onDispose(service.dispose);
  return service;
}

@riverpod
Stream<Duration> audioPosition(Ref ref) {
  final service = ref.watch(audioServiceProvider);
  return service.positionStream;
}

@riverpod
Stream<PlayerState> audioPlayerState(Ref ref) {
  final service = ref.watch(audioServiceProvider);
  return service.playerStateStream;
}

@riverpod
Stream<Duration?> audioDuration(Ref ref) {
  final service = ref.watch(audioServiceProvider);
  return service.durationStream;
}

@riverpod
Stream<double> audioSpeed(Ref ref) {
  final service = ref.watch(audioServiceProvider);
  return service.speedStream;
}