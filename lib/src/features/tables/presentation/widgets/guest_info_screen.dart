// lib/src/features/tables/presentations/pages/guest_info_screen.dart
import 'package:flutter/material.dart';
import '../pages/add_guest_order_screen.dart';

class GuestInfoScreen extends StatelessWidget {
  final String tableId;
  final int capacity;

  const GuestInfoScreen({
    super.key,
    required this.tableId,
    required this.capacity,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Гости: стол №${tableId.replaceAll('table_', '')}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(
            capacity,
            (index) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Иконка гостя и текст
                  Row(
                    children: [
                      const Icon(
                        Icons.person,
                        size: 32,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Гость ${index + 1}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  // Кнопка "Плюс"
                  IconButton(
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
                    icon: const Icon(
                      Icons.add,
                      size: 32, // Размер равен иконке Icons.person
                      // color: Colors.blue,
                    ),
                    tooltip: 'Добавить заказ для гостя ${index + 1}',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
