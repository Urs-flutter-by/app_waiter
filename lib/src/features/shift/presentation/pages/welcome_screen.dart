import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import 'halls_screen.dart';

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
            return const Center(child: Text('Ошибка авторизации: официант не найден'));
          }
          // Автоматический переход, если смена открыта
          if (state.isShiftOpen) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const HallsScreen(), // Убрали передачу halls
                ),
                    (route) => false,
              );
            });
          }
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Добро пожаловать, ${state.waiter!.username}!'),
                const SizedBox(height: 20),
                if (state.isShiftOpen) ...[
                  Text('Смена открыта с ${state.openedAt ?? 'неизвестного времени'}'),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      final notifier = ref.read(authProvider.notifier);
                      // Если залы еще не загружены, загружаем их
                      if (state.halls == null || state.halls!.isEmpty) {
                        try {
                          await notifier.loadHalls(state.waiter!, 'rest_12345');
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HallsScreen(), // Убрали передачу halls
                            ),
                                (route) => false,
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Ошибка: $e')),
                          );
                        }
                      } else {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HallsScreen(), // Убрали передачу halls
                          ),
                              (route) => false,
                        );
                      }
                    },
                    child: const Text('Перейти к столам'),
                  ),
                ] else ...[
                  ElevatedButton(
                    onPressed: () async {
                      final notifier = ref.read(authProvider.notifier);
                      try {
                        await notifier.openShift(state.waiter!, 'rest_12345');
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Смена открыта!')),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Ошибка: $e')),
                        );
                      }
                    },
                    child: const Text('Открыть смену'),
                  ),
                ],
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