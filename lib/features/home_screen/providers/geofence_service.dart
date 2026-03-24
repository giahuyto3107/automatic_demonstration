import 'dart:async';

import 'package:automatic_demonstration/features/home_screen/data/models/food_stall_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'geofence_service.g.dart';

enum GeofenceState { outside, entering, triggered, cooldown }

class GeofenceStatus {
  final GeofenceState state;
  final DateTime? countdownStartTime;
  final DateTime? lastTriggeredTime;

  GeofenceStatus({
    this.state = GeofenceState.outside,
    this.countdownStartTime,
    this.lastTriggeredTime,
  });

  GeofenceStatus copyWith({
    GeofenceState? state,
    DateTime? countdownStartTime,
    DateTime? lastTriggeredTime,
  }) {
    return GeofenceStatus(
      state: state ?? this.state,
      countdownStartTime: countdownStartTime ?? this.countdownStartTime,
      lastTriggeredTime: lastTriggeredTime ?? this.lastTriggeredTime,
    );
  }
}

@Riverpod(keepAlive: true)
class GeofenceService extends _$GeofenceService {
  StreamSubscription<Position>? _positionSubscription;
  Timer? _countdownTimer;
  Timer? _cooldownCheckTimer;
  final Map<int, GeofenceStatus> _stallStatuses = {};
  List<FoodStallModel> _currentStalls = [];
  Position? _lastPosition;

  static const int _triggerCountdownSeconds = 3;
  static const int _cooldownMinutes = 1;

  @override
  Map<int, GeofenceState> build() {
    ref.onDispose(() {
      _positionSubscription?.cancel();
      _countdownTimer?.cancel();
      _cooldownCheckTimer?.cancel();
    });

    _cooldownCheckTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      if (_lastPosition != null && _currentStalls.isNotEmpty) {
        _checkGeofences(_lastPosition!, _currentStalls);
      }
    });

    // Default to empty map
    return {};
  }

  void initialize(List<FoodStallModel> stalls) {
    if (_stallStatuses.isNotEmpty) return; // Prevent re-initialization reset
    _currentStalls = stalls;
    _listenToLocation(stalls);
  }

  void updateStalls(List<FoodStallModel> stalls) {
    _currentStalls = stalls;
    _listenToLocation(stalls);
  }

  void _listenToLocation(List<FoodStallModel> stalls) {
    _positionSubscription?.cancel();
    _positionSubscription =
        Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.best,
            distanceFilter: 2, // Check every 2 meters
          ),
        ).listen((position) {
          _lastPosition = position;
          _checkGeofences(position, stalls);
        });
  }

  void _checkGeofences(Position position, List<FoodStallModel> stalls) {
    final Map<int, GeofenceState> newState = Map.from(state);
    bool stateChanged = false;
    final now = DateTime.now();

    final distances = <int, double>{};
    for (final stall in stalls) {
      distances[stall.id] = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        stall.latitude,
        stall.longitude,
      );
    }

    final insideStalls = stalls.where((s) {
      final dist = distances[s.id]!;
      return dist <= s.triggerRadius;
    }).toList();

    insideStalls.sort((a, b) {
      final distA = distances[a.id]!;
      final distB = distances[b.id]!;

      // If distances are very close (less than 1 meter difference), consider them the same
      // and sort by priority (lower priority value comes first).
      if ((distA - distB).abs() < 1.0) {
        final prioA = a.priority ?? 999999;
        final prioB = b.priority ?? 999999;
        final prioComparison = prioA.compareTo(prioB);
        if (prioComparison != 0) return prioComparison;
      }

      return distA.compareTo(distB);
    });

    FoodStallModel? activeStall;
    if (insideStalls.isNotEmpty) {
      final closestStall = insideStalls.first;
      final status = _stallStatuses[closestStall.id] ?? GeofenceStatus();
      bool inCooldown = false;
      if (status.state == GeofenceState.cooldown) {
        if (status.lastTriggeredTime != null &&
            now.difference(status.lastTriggeredTime!).inMinutes <
                _cooldownMinutes) {
          inCooldown = true;
        }
      }
      if (!inCooldown) {
        activeStall = closestStall;
      }
    }

    for (final stall in stalls) {
      var status = _stallStatuses[stall.id] ?? GeofenceStatus();

      // Handle Cooldown Expiration
      if (status.state == GeofenceState.cooldown) {
        if (status.lastTriggeredTime != null &&
            now.difference(status.lastTriggeredTime!).inMinutes >=
                _cooldownMinutes) {
          status = status.copyWith(state: GeofenceState.outside);
          // Make sure it saves the state regardless of whether inside or outside
          _stallStatuses[stall.id] = status;
        } else {
          continue; // Still in cooldown
        }
      }

      final isInsideRadius =
          (activeStall != null && activeStall.id == stall.id);

      if (isInsideRadius) {
        if (status.state == GeofenceState.outside) {
          // Just entered
          status = status.copyWith(
            state: GeofenceState.entering,
            countdownStartTime: now,
          );
          _stallStatuses[stall.id] = status;
          newState[stall.id] = GeofenceState.entering;
          stateChanged = true;

          _startCountdownCheck(stall.id);
        } else if (status.state == GeofenceState.entering) {
          // Handled by the check timer
        }
      } else {
        // Outside radius
        if (status.state == GeofenceState.entering) {
          // Left before triggered
          status = status.copyWith(
            state: GeofenceState.outside,
            countdownStartTime: null,
          );
          _stallStatuses[stall.id] = status;
          newState[stall.id] = GeofenceState.outside;
          stateChanged = true;
        } else if (status.state == GeofenceState.triggered) {
          // This shouldn't normally happen as it transitions to cooldown immediately, but good for safety
          status = status.copyWith(state: GeofenceState.outside);
          _stallStatuses[stall.id] = status;
          newState[stall.id] = GeofenceState.outside;
          stateChanged = true;
        }
      }
    }

    if (stateChanged) {
      state = newState;
    }
  }

  void _startCountdownCheck(int stallId) {
    Timer(const Duration(seconds: _triggerCountdownSeconds), () {
      final status = _stallStatuses[stallId];
      if (status != null && status.state == GeofenceState.entering) {
        // Did not leave the area. Trigger!
        _stallStatuses[stallId] = status.copyWith(
          state: GeofenceState.triggered,
          lastTriggeredTime: DateTime.now(),
        );

        // Output new state to notify UI
        final newState = Map<int, GeofenceState>.from(state);
        newState[stallId] = GeofenceState.triggered;
        state = newState;

        // Immediately transition to cooldown
        Future.microtask(() {
          _stallStatuses[stallId] = _stallStatuses[stallId]!.copyWith(
            state: GeofenceState.cooldown,
          );

          final nextState = Map<int, GeofenceState>.from(state);
          nextState[stallId] = GeofenceState.cooldown;
          state = nextState;
        });
      }
    });
  }

  // Method to allow users to manually play without triggering cooldown,
  // or maybe it should? For now just trigger state change
  void manualTrigger(int stallId) {
    final newState = Map<int, GeofenceState>.from(state);
    newState[stallId] = GeofenceState.triggered;
    state = newState;

    _stallStatuses[stallId] = (_stallStatuses[stallId] ?? GeofenceStatus())
        .copyWith(
          state: GeofenceState.cooldown,
          lastTriggeredTime: DateTime.now(),
        );

    Future.microtask(() {
      final nextState = Map<int, GeofenceState>.from(state);
      nextState[stallId] = GeofenceState.cooldown;
      state = nextState;
    });
  }
}
