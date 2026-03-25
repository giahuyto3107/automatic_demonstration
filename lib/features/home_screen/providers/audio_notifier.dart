import 'package:automatic_demonstration/core/providers/app_locale.dart';
import 'package:automatic_demonstration/features/home_screen/providers/audio_service_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'audio_notifier.g.dart';

@Riverpod(keepAlive: true)
class AudioNotifier extends _$AudioNotifier {
  @override
  AsyncValue<String?> build() => const AsyncData(null);

  Future<void> load(String url) async {
    if (state.value == url) return;

    if (state.isLoading && state.value == url) return;

    state = const AsyncLoading();
    final service = ref.read(audioServiceProvider);
    
    // Lấy ngôn ngữ hiện tại của user để load đúng file audio
    final locale = ref.read(appLocaleProvider).languageCode;
    
    try {
      await service.initAudio(url, localeCode: locale);
      if (!state.isLoading) return;
      state = AsyncData(url);
    } catch (e, st) {
      if (e.toString().contains('interrupted')) {
        // Ignore interruption as it means another load started
        return;
      }
      print("AudioNotifier Error: $e");
      // Mặc dù lỗi, nếu app cần cho qua để UI không kẹt, có thể gán AsyncData(null)
      // nhưng tốt nhất là throw Error để UI handle
      state = AsyncError(e, st);
    }
  }

  void pause() => ref.read(audioServiceProvider).pause();
  void resume() => ref.read(audioServiceProvider).resume();
  void stop() => ref.read(audioServiceProvider).stop();
  void seek(Duration position) => ref.read(audioServiceProvider).seek(position);
  void setSpeed(double speed) => ref.read(audioServiceProvider).setSpeed(speed);
}
