// // lib/src/features/tables/presentation/pages/table_request_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/widgets/action_section.dart';
import '../../../orders/data/models/order_model.dart';
import '../../../orders/presentation/providers/order_provider.dart';
import '../../../requests/data/models/waiter_request.dart';
import '../../../requests/presentation/providers/waiter_request_provider.dart';
import '../providers/halls_provider.dart';
import '../widgets/table_info_widget.dart';
import '../../data/models/table_model.dart';

class TableRequestScreen extends ConsumerWidget {
  final TableModel table;

  const TableRequestScreen({super.key, required this.table});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _TableRequestScreenContent(table: table, ref: ref);
  }
}

class _TableRequestScreenContent extends StatefulWidget {
  final TableModel table;
  final WidgetRef ref;

  const _TableRequestScreenContent({
    required this.table,
    required this.ref,
  });

  @override
  _TableRequestScreenContentState createState() =>
      _TableRequestScreenContentState();
}

class _TableRequestScreenContentState
    extends State<_TableRequestScreenContent> {
  bool _isRequestConfirmed = false;
  bool _isOrderConfirmed = false;

  void _onRequestConfirmed() {
    setState(() {
      _isRequestConfirmed = true;
    });
  }

  void _onOrderConfirmed() {
    setState(() {
      _isOrderConfirmed = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final hallsAsync = widget.ref.watch(hallsStreamProvider);

    // Ищем название зала
    String hallName = 'Зал не указан';
    hallsAsync.when(
      data: (halls) {
        for (final hall in halls) {
          if (hall.tables
              .any((table) => table.tableId == widget.table.tableId)) {
            hallName = hall.name;
            break;
          }
        }
      },
      loading: () {
        hallName = 'Загрузка...';
      },
      error: (error, stack) {
        hallName = 'Ошибка';

      },
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(hallName),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TableInfoWidget(table: widget.table),
              ActionSection<WaiterRequest>(
                tableId: widget.table.tableId,
                hasNewItem: widget.table.hasGuestRequest,
                hasInProgressItem: widget.table.hasInProgressRequest,
                isConfirmed: _isRequestConfirmed,
                onConfirmed: _onRequestConfirmed,
                title: 'Запрос',
                itemIdField: 'requestId',
                provider: waiterRequestProvider(widget.table.tableId),
                repository: widget.ref.read(requestRepositoryProvider),
                itemBuilder: (request) => Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          request.message,
                          style: const TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Статус: ${request.status}',
                          style:
                              const TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Время: ${request.createdAt.toString() ?? 'Не указано'}',
                          style:
                              const TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              ActionSection<OrderModel>(
                tableId: widget.table.tableId,
                hasNewItem: widget.table.hasNewOrder,
                hasInProgressItem: widget.table.hasInProgressOrder,
                isConfirmed: _isOrderConfirmed,
                onConfirmed: _onOrderConfirmed,
                title: 'Заказ',
                itemIdField: 'orderId',
                provider: orderProvider(widget.table.tableId),
                repository: widget.ref.read(orderRepositoryProvider),
                itemBuilder: (order) => ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: order.items.length,
                  itemBuilder: (context, index) {
                    final item = order.items[index];
                    return ListTile(
                      title: Text(item.dish.name),
                      subtitle: Text(
                        'Количество: ${item.quantity} | Статус: ${item.status} | Время: ${item.createdAt?.toString() ?? 'Не указано'}',
                      ),
                      trailing: Text('\$${item.dish.price * item.quantity}'),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
