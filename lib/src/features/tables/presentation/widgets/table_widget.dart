// lib/src/features/tables/presentation/widgets/table_widget.dart
import 'package:flutter/material.dart';
import '../../data/models/table_model.dart';
import '../pages/table_request_screen.dart';

class TableWidget extends StatelessWidget {
  final TableModel table;
  final bool isDragging;

  const TableWidget({
    super.key,
    required this.table,
    this.isDragging = false,
  });

  @override
  Widget build(BuildContext context) {
    Color tableColor;
    if (!table.isOwn) {
      tableColor = Colors.grey;
    } else if (table.status == 'free') {
      tableColor = Colors.green;
    } else {
      tableColor = Colors.orange[200]!;
    }

    final showBell = table.hasNewOrder || table.hasGuestRequest;

    return GestureDetector(
      onTap: () {
        if (showBell) {
          // Открываем экран с запросами/заказами, если есть уведомления
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TableRequestScreen(table: table),
            ),
          );
        }
      },
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomRight,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: tableColor,
              border: Border.all(color: Colors.black, width: 2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                table.tableId.replaceAll('table_', ''),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          if (showBell && !isDragging)
            Positioned(
              top: -15,
              child: const Icon(
                Icons.notifications_active,
                color: Colors.red,
                size: 24,
              ),
            ),
        ],
      ),
    );
  }
}