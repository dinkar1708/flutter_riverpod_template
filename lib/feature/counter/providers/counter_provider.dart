import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'counter_provider.g.dart';

/// Counter provider using the latest Riverpod 3.0 AsyncNotifier pattern
/// This demonstrates:
/// - Notifier pattern for mutable state
/// - Synchronous state management
/// - Methods for state mutation
@riverpod
class Counter extends _$Counter {
  @override
  int build() {
    // Initialize counter to 0
    // You can add lifecycle listeners here if needed
    ref.onDispose(() {
      // Cleanup when provider is disposed
      debugPrint('Counter provider disposed');
    });

    return 0;
  }

  /// Increment the counter by 1
  void increment() {
    state = state + 1;
  }

  /// Decrement the counter by 1
  void decrement() {
    if (state > 0) {
      state = state - 1;
    }
  }

  /// Reset the counter to 0
  void reset() {
    state = 0;
  }

  /// Set the counter to a specific value
  void setValue(int value) {
    state = value;
  }
}
