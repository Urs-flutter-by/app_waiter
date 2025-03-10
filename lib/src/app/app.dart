import 'package:flutter/material.dart';
import 'package:basic_template/src/features/auth/presentation/pages/home_page.dart';
import 'theme/app_theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Basic Template',
      theme: AppTheme.lightTheme, // Светлая тема
      darkTheme: AppTheme.darkTheme, // Тёмная тема
      themeMode: ThemeMode.system, // Использовать системные настройки
      home: const HomePage(), // Указываем MyHomePage как начальный экран
    );
  }
}
