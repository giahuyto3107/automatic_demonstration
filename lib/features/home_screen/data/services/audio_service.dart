import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:just_audio/just_audio.dart';

class AudioService {
  static final AudioService _instance = AudioService._();

  AudioService._();

  factory AudioService() => _instance;

  final AudioPlayer _player = AudioPlayer();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  String? _remoteUrl;
  String? _assetPath;
  bool _isOfflineMode = false;

  Stream<Duration> get positionStream => _player.positionStream;
  Stream<PlayerState> get playerStateStream => _player.playerStateStream;
  Stream<Duration?> get durationStream => _player.durationStream;
  Stream<double> get speedStream => _player.speedStream;

  Future<void> initAudio(String url, {String? assetPath, String? localeCode}) async {
    if (url.isEmpty) {
      throw Exception('Audio URL is empty');
    }

    String finalUrl = url;
    // Chuyển đổi đuôi file sang locale hiện tại nếu có (Ví dụ: 8_vi.mp3 -> 8_ja.mp3)
    if (localeCode != null && localeCode.isNotEmpty) {
      finalUrl = finalUrl.replaceAll(RegExp(r'_[a-zA-Z]+\.mp3', caseSensitive: false), '_$localeCode.mp3');
    }
    
    _remoteUrl = finalUrl;
    
    // Tự động suy luận đường dẫn asset offline nếu không được truyền vào
    if (assetPath == null || assetPath.isEmpty) {
      // Lấy tên file từ url (ví dụ: http://.../8_ja.mp3 -> 8_ja.mp3)
      final fileName = Uri.parse(finalUrl).pathSegments.last;
      _assetPath = 'assets/audio/$fileName';
    } else {
      _assetPath = assetPath;
    }

    // 1. Lắng nghe sự thay đổi mạng liên tục
    _setupConnectivityListener();

    // 2. Kiểm tra kết nối mạng lần đầu
    final connectivityResults = await Connectivity().checkConnectivity();
    await _playBasedOnConnectivity(connectivityResults);
  }

  Future<void> _playBasedOnConnectivity(List<ConnectivityResult> results) async {
    final isOffline = results.isEmpty || results.contains(ConnectivityResult.none);
    
    if (isOffline) {
      await _playOfflineFallback();
    } else {
      // --- CHẾ ĐỘ ONLINE ---
      print("Đang trực tuyến, kiểm tra kết nối với Server...");
      try {
        _isOfflineMode = false;
        // Thử tải audio từ server với giới hạn timeout (VD: 5 giây) để nếu server "chết" hay mất mạng thực tế thì fallback ngay
        await _player.setAudioSource(
          AudioSource.uri(Uri.parse(_remoteUrl!))
        ).timeout(const Duration(seconds: 5));
        _player.play();
      } catch (e) {
        print("Không thể kết nối đến server ($e), tự động chuyển qua Mode Offline");
        await _player.stop(); // Hủy bỏ quá trình load online đang bị treo
        await _playOfflineFallback();
      }
    }
  }

  Future<void> _playOfflineFallback() async {
    try {
      if (_assetPath != null && _assetPath!.isNotEmpty) {
        print("Phát chế độ ngoại tuyến, sử dụng file từ Assets: $_assetPath");
        _isOfflineMode = true;
        await _player.setAsset(_assetPath!); 
        _player.play();
      } else {
        print("Không tìm thấy đường dẫn Asset offline.");
        throw Exception("Not found asset path for offline mode");
      }
    } catch (e) {
      print("Lỗi phát nhạc offline: $e");
      rethrow; // Ném lỗi ra cho AudioNotifier bắt và xử lý state thay vì kẹt mãi
    }
  }

  void _setupConnectivityListener() {
    _connectivitySubscription ??= Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) async {
      final isOnline = results.isNotEmpty && !results.contains(ConnectivityResult.none);

      if (isOnline && _isOfflineMode && _remoteUrl != null) {
        await _switchToOnlineSource();
      }
    });
  }

  Future<void> _switchToOnlineSource() async {
    try {
      print("Phát hiện kết nối mạng, luân chuyển sang chất lượng Online...");
      final currentPosition = _player.position;
      final wasPlaying = _player.playing;

      _isOfflineMode = false;
      await _player.setAudioSource(
        AudioSource.uri(Uri.parse(_remoteUrl!)),
        initialPosition: currentPosition,
      );

      if (wasPlaying) {
        _player.play();
      }
    } catch (e) {
      print("Lỗi khi chuyển đổi nguồn âm thanh: $e");
    }
  }

  // Common Controls
  void pause() => _player.pause();
  void resume() => _player.play();
  void seek(Duration position) => _player.seek(position);
  void setSpeed(double speed) => _player.setSpeed(speed);
  void stop() => _player.stop();
  
  void dispose() {
    _connectivitySubscription?.cancel();
    _player.dispose();
  }
}
