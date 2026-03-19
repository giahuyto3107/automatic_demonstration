import 'package:just_audio/just_audio.dart';

class AudioService {
  static final AudioService _instance = AudioService._();

  AudioService._();

  factory AudioService() => _instance;

  final AudioPlayer _player = AudioPlayer();

  Stream<Duration> get positionStream => _player.positionStream;
  Stream<PlayerState> get playerStateStream => _player.playerStateStream;
  Stream<Duration?> get durationStream => _player.durationStream;

  Future<void> initAudio(String url) async {
    _player.play(); // Pre-emptive play call
    await _player.setAudioSource(
      AudioSource.uri(Uri.parse(url)),
    );
  }

  // Common Controls
  void pause() => _player.pause();
  void resume() => _player.play();
  void seek(Duration position) => _player.seek(position);
  void stop() => _player.stop();
  void dispose() => _player.dispose();
}
