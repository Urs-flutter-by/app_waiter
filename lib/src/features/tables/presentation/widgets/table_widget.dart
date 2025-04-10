import 'package:flutter/material.dart';
import '../../data/models/table_model.dart';

class TableWidget extends StatelessWidget {
  final TableModel table;
  final VoidCallback onTap;
  final bool isDragging;

  const TableWidget({
    super.key,
    required this.table,
    required this.onTap,
    this.isDragging = false,
  });

  @override
  Widget build(BuildContext context) {
    // Определяем цвет стола
    Color tableColor;
    if (!table.isOwn) {
      tableColor = Colors.grey;
    } else if (table.status == 'free') {
      tableColor = Colors.green;
    } else {
      tableColor = Colors.orange[200]!;
    }

    // Определяем, показывать ли колокольчик и его цвет
    final showRedBell =
        table.hasNewOrder || table.hasGuestRequest; // Красный для статуса "new"
    final showYellowBell = table.hasInProgressRequest ||
        table.hasInProgressOrder; // Жёлтый для статуса "in_progress"

    return GestureDetector(
      onTap: onTap, // Используем переданный onTap
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  table.tableId.replaceAll('table_', ''),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.person,
                      color: Colors.black45,
                      size: 16,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      '${table.capacity}',
                      style: const TextStyle(
                        color: Colors.black45,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Показываем колокольчик в зависимости от статуса
          if (!isDragging)
            Positioned(
              top: -15,
              child: () {
                if (showRedBell) {
                  return const Icon(
                    Icons.notifications_active,
                    color: Colors.red,
                    size: 24,
                  );
                } else if (showYellowBell) {
                  return const Icon(
                    Icons.notifications_active,
                    color: Colors.brown,
                    size: 24,
                  );
                }
                return const SizedBox.shrink();
              }(),
            ),
        ],
      ),
    );
  }
}