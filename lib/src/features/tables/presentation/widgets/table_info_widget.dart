// lib/src/features/tables/presentation/widgets/table_info_widget.dart
import 'package:flutter/material.dart';
import '../../data/models/table_model.dart';
import 'guest_info_screen.dart';

class TableInfoWidget extends StatelessWidget {
  final TableModel table;

  const TableInfoWidget({
    super.key,
    required this.table,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Стол №${table.tableId.replaceAll('table_', '')}',
          style: const TextStyle(
            fontSize: 18,
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GuestInfoScreen(
                  tableId: table.tableId,
                  capacity: table.capacity, // Передаём capacity
                ),
              ),
            );
          },
          splashColor: Colors.blue.withValues(),
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.all(4.0), // Увеличиваем область нажатия
            child: Row(
              children: [
                const Icon(
                  Icons.person,
                  color: Colors.blue, // Синий для кликабельности
                ),
                const SizedBox(width: 8),
                Text(
                  'Гостей: ${table.capacity}',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.blue, // Синий для кликабельности
                    decoration: TextDecoration.underline, // Подчёркивание
                    decorationColor: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

