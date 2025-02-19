import 'package:logger/logger.dart';

class AppLogger {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2, // Количество методов в стектрейсе
      errorMethodCount: 8, // Количество методов в стектрейсе для ошибок
      lineLength: 120, // Ширина лога
      colors: true, // Цвета в консоли
      printEmojis: true, // Эмоджи для уровней
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart, // Показывать время
    ),
  );

  static void logInfo(String message) {
    if (!isReleaseMode) {
      _logger.i(message);
    }
  }

  static void logError(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    if (!isReleaseMode) {
      _logger.e(message,  error: error,  stackTrace: stackTrace);
    }
  }

  static void logDebug(String message) {
    if (!isReleaseMode) {
      _logger.d(message);
    }
  }

  static void logWarning(String message) {
    if (!isReleaseMode) {
      _logger.w(message);
    }
  }

  /// Проверяем, является ли приложение запущенным в release-режиме
  static bool get isReleaseMode {
    return const bool.fromEnvironment('dart.vm.product');
  }
}