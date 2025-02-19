import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:basic_template/src/core/utils/logger.dart'; // Настройка логгера
import 'app.dart';

Future<void> bootstrap() async {
  // 1. Инициализация FlutterBinding
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Настройка логгера
  setupLogger();

  // 3. Дополнительные инициализации (например, базы данных, API)
  await initializeServices();

  // 4. Запуск приложения
  runApp(const ProviderScope(child: MyApp()));
}

void setupLogger() {
  if (!AppLogger.isReleaseMode) {
    AppLogger.logInfo('Logger initialized in DEBUG mode');
  }
}

Future<void> initializeServices() async {
  // Здесь можно добавить инициализацию сервисов (API, базы данных и т.д.)
  AppLogger.logInfo('Initializing services...');
}


