import 'package:just_audio/just_audio.dart';

class AudioService {
  static final AudioService _instance = AudioService._();

  AudioService._();

  factory AudioService() => _instance;

  final AudioPlayer _player = AudioPlayer();

  Stream<Duration> get positionStream => _player.positionStream;
  Stream<PlayerState> get playerStateStream => _player.playerStateStream;
  Stream<Duration?> get durationStream => _player.durationStream;
  Stream<double> get speedStream => _player.speedStream;

  Future<void> initAudio(String url) async {
    if (url.isEmpty) {
      throw Exception('Audio URL is empty');
    }
    try {
      await _player.setAudioSource(AudioSource.uri(Uri.parse(url)));
      _player.play();
    } catch (e) {
      // Log or handle the 404 (and other errors) so it doesn't crash the app silently or cause playback loops
      print("Error loading audio source for url $url: $e");
      rethrow;
    }
  }

  // Common Controls
  void pause() => _player.pause();
  void resume() => _player.play();
  void seek(Duration position) => _player.seek(position);
  void setSpeed(double speed) => _player.setSpeed(speed);
  void stop() => _player.stop();
  void dispose() => _player.dispose();
}
