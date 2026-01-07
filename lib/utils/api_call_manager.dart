import 'dart:async';
import 'package:flutter/foundation.dart';

/// Manager class to handle API calls with debounce and loading state management
class ApiCallManager {
  static final Map<String, bool> _loadingStates = {};
  static final Map<String, DateTime> _lastCallTimes = {};
  static const Duration _defaultCooldown = Duration(seconds: 3);
  
  /// Executes an API call with debounce protection
  /// [key] - Unique identifier for the API call
  /// [apiCall] - The async function to execute
  /// [cooldownDuration] - Time to wait between calls (default: 3 seconds)
  /// [onLoading] - Optional callback when loading state changes
  /// Returns true if call was executed, false if blocked by cooldown
  static Future<bool> executeApiCall({
    required String key,
    required Future<void> Function() apiCall,
    Duration? cooldownDuration,
    Function(bool isLoading)? onLoading,
  }) async {
    final cooldown = cooldownDuration ?? _defaultCooldown;
    
    // Check if already loading
    if (_loadingStates[key] == true) {
      debugPrint('API call blocked: $key is already in progress');
      return false;
    }
    
    // Check cooldown
    final lastCall = _lastCallTimes[key];
    final now = DateTime.now();
    
    if (lastCall != null && now.difference(lastCall) < cooldown) {
      final remainingTime = cooldown - now.difference(lastCall);
      debugPrint('API call blocked: $key is in cooldown for ${remainingTime.inMilliseconds}ms');
      return false;
    }
    
    try {
      // Set loading state
      _loadingStates[key] = true;
      _lastCallTimes[key] = now;
      onLoading?.call(true);
      
      debugPrint('Executing API call: $key');
      
      // Execute the API call
      await apiCall();
      
      debugPrint('API call completed: $key');
      return true;
      
    } catch (error) {
      debugPrint('API call failed: $key - $error');
      rethrow;
    } finally {
      // Always clear loading state
      _loadingStates[key] = false;
      onLoading?.call(false);
    }
  }
  
  /// Checks if an API call is currently loading
  static bool isLoading(String key) {
    return _loadingStates[key] == true;
  }
  
  /// Checks if an API call can be made (not in cooldown)
  static bool canMakeCall(String key, [Duration? cooldownDuration]) {
    final cooldown = cooldownDuration ?? _defaultCooldown;
    final lastCall = _lastCallTimes[key];
    
    if (lastCall == null) return true;
    if (_loadingStates[key] == true) return false;
    
    final now = DateTime.now();
    return now.difference(lastCall) >= cooldown;
  }
  
  /// Gets remaining cooldown time for an API call
  static Duration getRemainingCooldown(String key, [Duration? cooldownDuration]) {
    final cooldown = cooldownDuration ?? _defaultCooldown;
    final lastCall = _lastCallTimes[key];
    
    if (lastCall == null) return Duration.zero;
    
    final now = DateTime.now();
    final elapsed = now.difference(lastCall);
    
    if (elapsed >= cooldown) return Duration.zero;
    return cooldown - elapsed;
  }
  
  /// Clears all stored states
  static void clearAll() {
    _loadingStates.clear();
    _lastCallTimes.clear();
  }
  
  /// Clears state for a specific key
  static void clear(String key) {
    _loadingStates.remove(key);
    _lastCallTimes.remove(key);
  }
}