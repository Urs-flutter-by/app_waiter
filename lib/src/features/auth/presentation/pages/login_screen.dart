import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// import '../../../../core/widgets/async_value_widget.dart';
// import '../../domain/entities/waiter.dart';
import '../../../shift/presentation/pages/welcome_screen.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends ConsumerWidget {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final String restaurantId; // Получаем из QR-кода

  LoginScreen({super.key, required this.restaurantId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Логин'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Пароль'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final notifier = ref.read(authProvider.notifier);
                await notifier.signIn(
                  _usernameController.text,
                  _passwordController.text,
                  restaurantId,
                );
                final authState = ref.watch(authProvider);
                if (authState.value?.waiter != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const WelcomeScreen()),
                  );
                }
              },
              child: const Text('Войти'),
            ),
            const SizedBox(height: 20),
            authState.when(
              data: (state) {
                if (state.isInitial) {
                  return const SizedBox.shrink(); // Ничего не показываем при начальном состоянии
                }
                return state.waiter != null
                    ? Text('Welcome, ${state.waiter!.username}!')
                    : const Text('Ошибка авторизации', style: TextStyle(color: Colors.red));
              },
              loading: () => const CircularProgressIndicator(),
              error: (error, stack) {
                if (error is DioException) {
                  if (error.response?.statusCode == 401) {
                    return const Text(
                      'Неверный логин или пароль',
                      style: TextStyle(color: Colors.red),
                    );
                  } else if (error.response?.statusCode == 404) {
                    return const Text(
                      'Ошибка: сервис недоступен',
                      style: TextStyle(color: Colors.red),
                    );
                  } else {
                    return Text(
                      'Ошибка: ${error.message}',
                      style: TextStyle(color: Colors.red),
                    );
                  }
                }
                return Text(
                  'Неизвестная ошибка: $error',
                  style: TextStyle(color: Colors.red),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
