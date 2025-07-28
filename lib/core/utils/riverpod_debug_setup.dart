import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'riverpod_debug_observer.dart';

/// Example setup for Riverpod debug mode
/// 
/// Usage in main.dart:
/// ```dart
/// void main() async {
///   // ... initialization code ...
///   
///   runApp(
///     setupRiverpodDebug(
///       child: const OjyxApp(),
///     ),
///   );
/// }
/// ```
Widget setupRiverpodDebug({required Widget child}) {
  // Check if debug mode should be enabled
  final shouldDebug = RiverpodDebugObserver.isDebugEnvironment;
  
  if (shouldDebug) {
    // Use ProviderScope with debug observer
    return ProviderScope(
      observers: [RiverpodDebugObserver()],
      child: child,
    );
  } else {
    // Normal ProviderScope without debug observer
    return ProviderScope(
      child: child,
    );
  }
}

/// Alternative: Enable debug mode programmatically
/// 
/// Usage:
/// ```dart
/// void main() async {
///   // Enable Riverpod debug in development
///   if (kDebugMode) {
///     RiverpodDebugObserver.debugMode = true;
///   }
///   
///   runApp(
///     ProviderScope(
///       observers: [RiverpodDebugObserver()],
///       child: const OjyxApp(),
///     ),
///   );
/// }
/// ```
void enableRiverpodDebugInDevelopment() {
  RiverpodDebugObserver.debugMode = true;
}