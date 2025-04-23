// lib/src/features/tables/presentations/pages/add_guest_order_screen.dart
import 'package:flutter/material.dart';

class AddGuestOrderScreen extends StatelessWidget {
  final String tableId;
  final int guestIndex;

  const AddGuestOrderScreen({
    super.key,
    required this.tableId,
    required this.guestIndex,
  });

  @override
  Widget build(BuildContext context) {
    final guestNumber = guestIndex + 1; // Номер гостя для отображения (1-based)
    final tableNumber = tableId.replaceAll('table_', '');

    return Scaffold(
      appBar: AppBar(
        title: Text('Заказ для гостя $guestNumber, стол №$tableNumber'),
      ),
      body: Center(
        child: Text(
          'Страница добавления заказа для гостя $guestNumber, '
          'стол №$tableNumber (в разработке)',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
