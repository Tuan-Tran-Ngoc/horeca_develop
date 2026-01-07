import 'dart:async';
import 'package:flutter/foundation.dart';

/// Utility class to prevent multiple rapid function calls (debouncing)
class Debouncer {
  static final Map<String, Timer> _timers = {};
  static final Map<String, DateTime> _lastCallTimes = {};
  
  /// Prevents a function from being called multiple times within a specified duration
  /// [key] - Unique identifier for the debouncer
  /// [duration] - Minimum time between function calls
  /// [action] - Function to execute
  static void debounce(String key, Duration duration, VoidCallback action) {
    // Cancel any existing timer for this key
    _timers[key]?.cancel();
    
    // Check if enough time has passed since last call
    final now = DateTime.now();
    final lastCall = _lastCallTimes[key];
    
    if (lastCall != null && now.difference(lastCall) < duration) {
      // Not enough time has passed, schedule for later
      final remaining = duration - now.difference(lastCall);
      _timers[key] = Timer(remaining, () {
        _lastCallTimes[key] = DateTime.now();
        action();
      });
    } else {
      // Enough time has passed or first call, execute immediately
      _lastCallTimes[key] = now;
      action();
    }
  }
  
  /// Checks if a function can be called (not in cooldown period)
  static bool canCall(String key, Duration duration) {
    final lastCall = _lastCallTimes[key];
    if (lastCall == null) return true;
    
    final now = DateTime.now();
    return now.difference(lastCall) >= duration;
  }
  
  /// Clears all stored timers and call times
  static void clearAll() {
    for (var timer in _timers.values) {
      timer.cancel();
    }
    _timers.clear();
    _lastCallTimes.clear();
  }
  
  /// Clears timer and call time for a specific key
  static void clear(String key) {
    _timers[key]?.cancel();
    _timers.remove(key);
    _lastCallTimes.remove(key);
  }
}

/// Extension to add debounce functionality to VoidCallback
extension DebouncedCallback on VoidCallback {
  VoidCallback debounce(String key, Duration duration) {
    return () => Debouncer.debounce(key, duration, this);
  }
}