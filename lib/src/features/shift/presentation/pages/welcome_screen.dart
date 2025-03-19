import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Добро пожаловать')),
      body: authState.when(
        data: (state) {
          if (state.waiter == null) {
            return const Center(child: Text('Ошибка авторизации'));
          }
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Добро пожаловать, ${state.waiter!.username}!'),
                const SizedBox(height: 20),
                if (state.isShiftOpen)
                  Text(
                      'Смена открыта с ${state.openedAt ?? 'неизвестного времени'}')
                else
                  ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Смена открыта!')),
                      );
                    },
                    child: const Text('Открыть смену'),
                  ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Ошибка: $error')),
      ),
    );
  }
}
