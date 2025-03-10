import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Basic Template'), // Название приложения
      ),
      body: Center(
        child: Text(
          'Welcome to the Basic Template!', // Простой текст в центре экрана
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}
