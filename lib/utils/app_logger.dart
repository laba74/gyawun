import 'package:flutter/foundation.dart';

/// Simple logging utility to replace print() statements.
///
/// Benefits:
/// - Conditional logging based on debug/release mode
/// - Consistent log formatting
/// - Easy to disable in production
/// - Can be extended to log to files or remote services
///
/// Usage:
/// ```dart
/// AppLogger.debug('Debug message');
/// AppLogger.info('Info message');
/// AppLogger.warning('Warning message');
/// AppLogger.error('Error message', error: exception);
/// ```
class AppLogger {
  static const String _tag = 'Gyawun';

  /// Enable/disable logging globally
  static bool enabled = kDebugMode;

  /// Log debug messages (only in debug mode)
  static void debug(String message, {String? tag}) {
    if (!enabled) return;
    if (kDebugMode) {
      print('🔍 [$_tag${tag != null ? ':$tag' : ''}] $message');
    }
  }

  /// Log info messages
  static void info(String message, {String? tag}) {
    if (!enabled) return;
    print('ℹ️  [$_tag${tag != null ? ':$tag' : ''}] $message');
  }

  /// Log warning messages
  static void warning(String message, {String? tag}) {
    if (!enabled) return;
    print('⚠️  [$_tag${tag != null ? ':$tag' : ''}] $message');
  }

  /// Log error messages with optional error object
  static void error(String message, {Object? error, StackTrace? stackTrace, String? tag}) {
    if (!enabled) return;
    print('❌ [$_tag${tag != null ? ':$tag' : ''}] $message');
    if (error != null) {
      print('   Error: $error');
    }
    if (stackTrace != null && kDebugMode) {
      print('   Stack trace:\n$stackTrace');
    }
  }

  /// Log success messages
  static void success(String message, {String? tag}) {
    if (!enabled) return;
    print('✅ [$_tag${tag != null ? ':$tag' : ''}] $message');
  }

  /// Log download-related messages (with custom emoji)
  static void download(String message, {String? tag}) {
    if (!enabled) return;
    print('⏬ [$_tag${tag != null ? ':$tag' : ''}] $message');
  }

  /// Log network-related messages
  static void network(String message, {String? tag}) {
    if (!enabled) return;
    print('🌐 [$_tag${tag != null ? ':$tag' : ''}] $message');
  }
}
