// lib/src/features/tables/presentation/widgets/order_section.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../orders/data/models/order_model.dart';
import '../../../orders/presentation/providers/order_provider.dart';
import '../providers/halls_provider.dart';

class OrderSection extends StatelessWidget {
  final String tableId;
  final bool hasNewOrder;
  final bool hasInProgressOrder;
  final bool isOrderConfirmed;
  final VoidCallback onOrderConfirmed;

  const OrderSection({
    super.key,
    required this.tableId,
    required this.hasNewOrder,
    required this.hasInProgressOrder,
    required this.isOrderConfirmed,
    required this.onOrderConfirmed,
  });

  Future<void> _confirmOrder(WidgetRef ref, OrderModel order) async {
    final repository = ref.read(orderRepositoryProvider);
    try {
      await repository.confirmOrder(tableId, order.orderId);
      ref.invalidate(orderProvider(tableId));
      ref.invalidate(hallsStreamProvider);
    } catch (e) {
      throw Exception('Failed to confirm order: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!(hasNewOrder || hasInProgressOrder)) {
      return const SizedBox.shrink();
    }

    return Consumer(
      builder: (context, ref, child) {
        final orderAsync = ref.watch(orderProvider(tableId));
        return orderAsync.when(
          data: (order) {
            if (order == null) {
              return const Text('Заказ не найден');
            }
            return Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    order.items.any((item) => item.status == 'new')
                        ? 'Оформлен заказ'
                        : 'Заказ обновлён',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView.builder(
                      itemCount: order.items.length,
                      itemBuilder: (context, index) {
                        final item = order.items[index];
                        return ListTile(
                          title: Text(item.dish.name),
                          subtitle: Text(
                            'Количество: ${item.quantity} | Статус: ${item.status} | Время: ${item.createdAt?.toString() ?? 'Не указано'}',
                          ),
                          trailing: Text('\$${item.totalPrice}'),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (order.items.any((item) => item.status == 'new'))
                    ElevatedButton(
                      onPressed: isOrderConfirmed
                          ? null
                          : () async {
                        try {
                          await _confirmOrder(ref, order);
                          onOrderConfirmed();
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Ошибка: $e')),
                          );
                        }
                      },
                      child: Text(isOrderConfirmed ? 'Подтверждено' : 'Подтвердить'),
                    ),
                  if (order.items.any((item) => item.status == 'in_progress'))
                    ElevatedButton(
                      onPressed: () {
                        // Логика для "Исполнено"
                      },
                      child: const Text('Исполнено'),
                    ),
                ],
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Text('Ошибка: $error'),
        );
      },
    );
  }
}