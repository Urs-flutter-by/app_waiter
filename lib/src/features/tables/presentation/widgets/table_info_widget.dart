// lib/src/features/tables/presentation/widgets/table_info_widget.dart
import 'package:flutter/material.dart';
import '../../data/models/table_model.dart';

class TableInfoWidget extends StatelessWidget {
  final TableModel table;

  const TableInfoWidget({
    super.key,
    required this.table,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Веранда', // Пока захардкодим
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
        const SizedBox(height: 8),
        Text(
          'Стол №${table.tableId.replaceAll('table_', '')}',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            const Icon(Icons.person, color: Colors.grey),
            const SizedBox(width: 8),
            Text(
              'Гостей: ${table.capacity}',
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}