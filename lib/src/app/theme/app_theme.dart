import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  // Светлая тема
  static final ThemeData lightTheme = ThemeData(
    // Основной цвет приложения (используется для кнопок, AppBar и т.д.)
    primaryColor: AppColors.appBarColor,

    // Фон всех экранов
    scaffoldBackgroundColor: AppColors.backgroundColor,

    // Настройки AppBar
    appBarTheme: AppBarTheme(
      // Цвет AppBar
      backgroundColor: AppColors.appBarColor,

      // Стиль текста в заголовке AppBar
      titleTextStyle: TextStyle(
        fontFamily: 'PlayfairDisplay', // Шрифт
        fontSize: 20, // Размер шрифта
        color: Colors.white, // Цвет текста
        fontWeight: FontWeight.bold, // Жирность
      ),

      // Цвет иконок в AppBar (например, стрелка назад)
      iconTheme: IconThemeData(
        color: AppColors.backgroundColor,
      ),
    ),

    // Настройки текстовых стилей
    textTheme: TextTheme(
      // Заголовок среднего размера
      headlineMedium: TextStyle(
        fontFamily: 'PlayfairDisplay',
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: AppColors.headlineTextColor,
      ),

      // Меньший заголовок
      headlineSmall: TextStyle(
        fontFamily: 'PlayfairDisplay',
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: AppColors.headlineTextColor,
      ),

      // Большой текст (например, основной контент)
      bodyLarge: TextStyle(
        fontFamily: 'PlayfairDisplay',
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.bodyTextColor,
      ),

      // Средний текст (например, описание)
      bodyMedium: TextStyle(
        fontFamily: 'PlayfairDisplay',
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.bodyTextColor,
      ),

      // Маленький текст (например, подсказки)
      bodySmall: TextStyle(
        fontFamily: 'PlayfairDisplay',
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.smallTextColor,
      ),

      // Большие метки (например, кнопки или элементы интерфейса)
      labelLarge: TextStyle(
        fontFamily: 'Roboto',
        fontSize: 24,
        color: AppColors.headlineTextColor,
      ),

      // Средние метки
      labelMedium: TextStyle(
        fontFamily: 'Roboto',
        fontSize: 18,
        color: AppColors.buttonTextColor,
      ),

      // Маленькие метки
      labelSmall: TextStyle(
        fontFamily: 'Roboto',
        fontSize: 16,
        color: AppColors.headlineTextColor,
      ),
    ),

    // Настройки ElevatedButton
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        // Цвет кнопки
        backgroundColor: AppColors.buttonColor,

        // Цвет текста на кнопке
        foregroundColor: AppColors.buttonTextColor,

        // Форма кнопки (округленные углы)
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),
  );

  // Темная тема (при необходимости)
  static final ThemeData darkTheme = ThemeData(
    // Основной цвет приложения
    primaryColor: Colors.teal[300],

    // Фон всех экранов
    scaffoldBackgroundColor: Colors.black,

    // Настройки AppBar
    appBarTheme: AppBarTheme(
      // Цвет AppBar
      backgroundColor: Colors.teal[300],

      // Стиль текста в заголовке AppBar
      titleTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),

      // Цвет иконок в AppBar
      iconTheme: const IconThemeData(color: Colors.white),
    ),

    // Настройки ElevatedButton
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        // Цвет кнопки
        backgroundColor: AppColors.appBarColor,

        // Цвет текста на кнопке
        foregroundColor: AppColors.buttonTextColor,

        // Размер кнопки
        minimumSize: const Size(150, 50),

        // Форма кнопки (округленные углы)
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    ),

    // Настройки текстовых стилей
    textTheme: const TextTheme(
      // Большой заголовок
      headlineMedium: TextStyle(
        fontSize: 32.0,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),

      // Обычный текст
      bodyMedium: TextStyle(
        fontSize: 16.0,
        color: Colors.white70,
      ),
    ),
  );
}
