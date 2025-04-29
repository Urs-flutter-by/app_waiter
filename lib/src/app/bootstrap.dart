import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:basic_template/src/core/utils/logger.dart'; // Настройка логгера
//import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
//import '../features/auth/presentation/pages/login_screen.dart';
import '../features/menu/data/models/dish_model.dart';
import '../features/orders/data/models/selected_dish.dart';
import '../features/qr_scan/presentation/pages/qr_scan_screen.dart';
//import 'app.dart';

// Глобальная переменная для бокса category_order
late Box<String> categoryOrderBox;

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
  // Инициализируем Hive
  await Hive.initFlutter();
  Hive.registerAdapter(OffsetAdapter());
  Hive.registerAdapter(DishModelAdapter());
  Hive.registerAdapter(SelectedDishAdapter());

  // Открываем бокс для порядка категорий
  categoryOrderBox = await Hive.openBox<String>('category_order'); // Изменили тип на Box<String>
  // Очищаем старые данные (для миграции)
  // await categoryOrderBox.clear();
  AppLogger.logInfo('Hive initialized with categoryOrderBox: ${categoryOrderBox.isOpen}');

  //await Hive.openBox('positions'); // Открываем хранилище

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Waiter App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const QRScanScreen(), // Стартуем с экрана авторизации
    );
  }
}
// Адаптер для хранения Offset
class OffsetAdapter extends TypeAdapter<Offset> {
  @override
  final int typeId = 0; // Уникальный ID для типа

  @override
  Offset read(BinaryReader reader) {
    final dx = reader.readDouble();
    final dy = reader.readDouble();
    return Offset(dx, dy);
  }

  @override
  void write(BinaryWriter writer, Offset obj) {
    writer.writeDouble(obj.dx);
    writer.writeDouble(obj.dy);
  }
}


