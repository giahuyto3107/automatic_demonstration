import 'dart:async';
import 'dart:io';
import 'package:automatic_demonstration/core/network/endpoints.dart';
import 'package:automatic_demonstration/core/services/database_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AnalyticsService {
  static final AnalyticsService _instance = AnalyticsService._internal();

  factory AnalyticsService() {
    return _instance;
  }

  AnalyticsService._internal();

  String? _sessionId;
  String? _deviceId;
  String _platform = Platform.operatingSystem;

  // stallId -> StallActivityCount
  final Map<int, Map<String, int>> _eventBuffer = {};
  bool _isSyncing = false;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _deviceId = prefs.getString('analytics_device_id');
    if (_deviceId == null) {
      _deviceId = DateTime.now().millisecondsSinceEpoch.toString();
      await prefs.setString('analytics_device_id', _deviceId!);
    }
    _sessionId = 'session_${DateTime.now().millisecondsSinceEpoch}';
  }

  void trackPlay(int stallId, {bool isAuto = false}) {
    print('Analytics: trackPlay stallId=$stallId isAuto=$isAuto');
    _increment(stallId, isAuto ? 'autoPlay' : 'manualPlay');
  }

  void trackSkip(int stallId) {
    _increment(stallId, 'skip');
  }

  void trackFinish(int stallId) {
    _increment(stallId, 'finish');
  }

  void _increment(int stallId, String action) {
    if (!_eventBuffer.containsKey(stallId)) {
      _eventBuffer[stallId] = {
        'manualPlay': 0,
        'autoPlay': 0,
        'skip': 0,
        'finish': 0,
      };
    }
    _eventBuffer[stallId]![action] = (_eventBuffer[stallId]![action] ?? 0) + 1;
    print('Analytics: buffered $action for stall $stallId (new count: ${_eventBuffer[stallId]![action]})');
  }

  Future<void> flush() async {
    if (_isSyncing || _eventBuffer.isEmpty) return;
    _isSyncing = true;

    try {
      final deviceId = _deviceId ?? 'unknown_device';
      final sessionId = _sessionId ?? 'unknown_session';

      // Capture the current buffer state for this sync
      final currentBuffer = Map<int, Map<String, int>>.from(_eventBuffer);

      final stalls = currentBuffer.entries.map((e) {
        return {
          'stallId': e.key,
          'manualPlay': e.value['manualPlay'],
          'autoPlay': e.value['autoPlay'],
          'skip': e.value['skip'],
          'finish': e.value['finish'],
        };
      }).toList();

      final batchRequest = {
        'deviceId': deviceId,
        'sessionId': sessionId,
        'platform': _platform,
        'stalls': stalls,
      };

      print('--------------- ANALYTICS PUSH ---------------');
      print('Endpoint: ${Endpoints.trackBatch}');
      print('Payload: $batchRequest');
      print('----------------------------------------------');

      final response = await DatabaseService.instance.post(
        Endpoints.trackBatch,
        data: [batchRequest],
      );

      if (response.isSuccess) {
        // Only remove the entries we successfully sent
        for (var stallId in currentBuffer.keys) {
          _eventBuffer.remove(stallId);
        }
        print('Analytics: Push success');
      } else {
        print('Analytics: Push failure: ${response.message ?? "Unknown error"}');
      }
    } catch (e) {
      print('Analytics: Push exception: $e');
    } finally {
      _isSyncing = false;
    }
  }
}
