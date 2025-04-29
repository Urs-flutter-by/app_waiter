// lib/src/features/tables/presentation/pages/guest_info_screen.dart
import 'package:basic_template/src/features/tables/presentation/pages/add_guest_order_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../orders/presentation/providers/selected_dishes_provider.dart';

class GuestInfoScreen extends ConsumerWidget {
  final String tableId;
  final int capacity;

  const GuestInfoScreen({
    super.key,
    required this.tableId,
    required this.capacity,
  });

  // Метод для отображения всплывающего окна с заказами
  void _showOrdersDialog(BuildContext context, WidgetRef ref, int guestNumber,
      String selectedDishesKey) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return Consumer(
          builder: (context, ref, child) {
            final selectedDishes =
                ref.watch(selectedDishesProvider(selectedDishesKey));
            final orderedDishes =
                selectedDishes.where((dish) => dish.quantity > 0).toList();

            if (orderedDishes.isEmpty) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.pop(dialogContext);
              });
              return const SizedBox.shrink();
            }

            return AlertDialog(
              title: Text('Заказы Гостя $guestNumber'),
              content: SizedBox(
                width: double.maxFinite,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: orderedDishes.length,
                  itemBuilder: (context, index) {
                    final dish = orderedDishes[index];
                    return ListTile(
                      title: Text(dish.dish.name),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              ref
                                  .read(
                                      selectedDishesProvider(selectedDishesKey)
                                          .notifier)
                                  .removeDish(dish.dish);
                            },
                            icon: const Icon(Icons.remove,
                                color: Colors.white, size: 16),
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: const CircleBorder(),
                              minimumSize: const Size(32, 32),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              '${dish.quantity}',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              ref
                                  .read(
                                      selectedDishesProvider(selectedDishesKey)
                                          .notifier)
                                  .addDish(dish.dish);
                            },
                            icon: const Icon(Icons.add,
                                color: Colors.white, size: 16),
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: const CircleBorder(),
                              minimumSize: const Size(32, 32),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Закрыть'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Метод для проверки, есть ли заказы у столика
  bool _hasOrders(WidgetRef ref) {
    for (int index = 0; index < capacity; index++) {
      final selectedDishesKey = '${tableId}_$index';
      final selectedDishes =
          ref.watch(selectedDishesProvider(selectedDishesKey));
      final totalDishes = selectedDishes.fold<int>(
        0,
        (sum, dish) => sum + (dish.quantity > 0 ? dish.quantity : 0),
      );
      if (totalDishes > 0) return true;
    }
    return false;
  }

  // Метод для имитации отправки заказа
  Future<void> _sendOrder(BuildContext context, WidgetRef ref) async {
    await Future.delayed(const Duration(seconds: 1));

    final guestOrders = <int, List<Map<String, dynamic>>>{};
    for (int index = 0; index < capacity; index++) {
      final selectedDishesKey = '${tableId}_$index';
      final selectedDishes =
          ref.read(selectedDishesProvider(selectedDishesKey));
      final orderedDishes = selectedDishes
          .where((dish) => dish.quantity > 0)
          .map((dish) => {
                'dishId': dish.dish.id,
                'name': dish.dish.name,
                'quantity': dish.quantity,
              })
          .toList();

      if (orderedDishes.isNotEmpty) {
        guestOrders[index] = orderedDishes;
      }
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Заказ успешно отправлен (имитация)'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  // Метод для отмены заказа
  Future<void> _cancelOrder(BuildContext context, WidgetRef ref) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Подтверждение'),
          content: const Text('Вы уверены, что хотите отменить заказ?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Нет'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Да'),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      // Очищаем заказы для всех гостей
      for (int index = 0; index < capacity; index++) {
        final selectedDishesKey = '${tableId}_$index';
        ref
            .read(selectedDishesProvider(selectedDishesKey).notifier)
            .clearDishes();
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tableNumber = tableId.replaceAll('table_', '');

    return Scaffold(
      appBar: AppBar(
        title: Text('Стол №$tableNumber'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: capacity,
              itemBuilder: (context, index) {
                final guestNumber = index + 1;
                final selectedDishesKey = '${tableId}_$index';
                final selectedDishes =
                    ref.watch(selectedDishesProvider(selectedDishesKey));

                final totalDishes = selectedDishes.fold<int>(
                  0,
                  (sum, dish) => sum + (dish.quantity > 0 ? dish.quantity : 0),
                );

                return ListTile(
                  leading: const Icon(Icons.person),
                  title: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Гость $guestNumber'),
                      const SizedBox(width: 8),
                      if (totalDishes > 0) ...[
                        const Icon(Icons.fastfood, size: 20),
                        const SizedBox(width: 4),
                        Text(
                          '$totalDishes',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 16,
                    ),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: const CircleBorder(),
                      minimumSize: const Size(32, 32),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddGuestOrderScreen(
                            tableId: tableId,
                            guestIndex: index,
                          ),
                        ),
                      );
                    },
                  ),
                  onTap: totalDishes > 0
                      ? () => _showOrdersDialog(
                          context, ref, guestNumber, selectedDishesKey)
                      : null,
                );
              },
            ),
          ),
          if (_hasOrders(ref)) ...[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => _sendOrder(context, ref),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                    ),
                    child: const Text('ОТПРАВИТЬ ЗАКАЗ'),
                  ),
                  ElevatedButton(
                    onPressed: () => _cancelOrder(context, ref),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                    ),
                    child: const Text('ОТМЕНИТЬ ЗАКАЗ'),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
