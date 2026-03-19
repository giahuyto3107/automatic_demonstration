import 'package:automatic_demonstration/features/home_screen/providers/audio_service_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'audio_notifier.g.dart';

@Riverpod(keepAlive: true)
class AudioNotifier extends _$AudioNotifier {
  @override
  AsyncValue<String?> build() => const AsyncData(null);

  Future<void> load(String url) async {
    if (state.value == url) {
      // Audio already loaded, don't restart
      return;
    }

    state = const AsyncLoading();
    final service = ref.read(audioServiceProvider);
    try {
      await service.initAudio(url);
      state = AsyncData(url);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  void pause() => ref.read(audioServiceProvider).pause();
  void resume() => ref.read(audioServiceProvider).resume();
  void seek(Duration position) => ref.read(audioServiceProvider).seek(position);
}