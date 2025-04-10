// lib/src/features/tables/presentation/widgets/hall_view.dart
// lib/src/features/tables/presentation/widgets/hall_view.dart
import 'package:flutter/material.dart';
import '../../data/models/hall_model.dart';
import '../../data/models/table_model.dart';
import 'grid_painter.dart';
import 'table_widget.dart';

class HallView extends StatelessWidget {
  final HallModel hall;
  final double gridSize;
  final double screenWidth;
  final double fixedHeight;
  final Map<String, Offset> tablePositions;
  final GlobalKey stackKey;
  final Function(String, Offset) onPositionChanged;
  final Function(TableModel) onTableTap;

  const HallView({
    super.key,
    required this.hall,
    required this.gridSize,
    required this.screenWidth,
    required this.fixedHeight,
    required this.tablePositions,
    required this.stackKey,
    required this.onPositionChanged,
    required this.onTableTap,
  });

  String getTableKey(TableModel table) {
    return '${hall.hallId}_${table.tableId}';
  }

  @override
  Widget build(BuildContext context) {
    const tableSize = 60.0; // Размер стола
    final offsetX = gridSize - tableSize; // Смещение по X (80 - 60 = 20)
    final offsetY = gridSize - tableSize; // Смещение по Y (80 - 60 = 20)

    return SingleChildScrollView(
      child: SizedBox(
        height: fixedHeight,
        width: screenWidth,
        child: Stack(
          key: stackKey,
          children: [
            DragTarget<TableModel>(
              onAcceptWithDetails: (details) {
                final table = details.data;
                final stackRenderBox =
                    stackKey.currentContext!.findRenderObject() as RenderBox;
                final localOffset =
                    stackRenderBox.globalToLocal(details.offset);

                final newX = (localOffset.dx / gridSize).round() * gridSize;
                final newY = (localOffset.dy / gridSize).round() * gridSize;
                final maxX = screenWidth - gridSize;
                final maxY = fixedHeight - gridSize;
                final clampedX = newX.clamp(0.0, maxX);
                final clampedY = newY.clamp(0.0, maxY);
                final newPosition = Offset(clampedX, clampedY);

                final currentTableKey = getTableKey(table);
                final occupiedPositions = tablePositions.entries
                    .where((entry) => entry.key.startsWith(hall.hallId))
                    .map((entry) => entry.value)
                    .toList();

                if (!occupiedPositions.any((pos) =>
                    pos == newPosition &&
                    pos != tablePositions[currentTableKey])) {
                  onPositionChanged(table.tableId, newPosition);
                }
              },
              builder: (context, candidateData, rejectedData) {
                return CustomPaint(
                  size: Size(screenWidth, fixedHeight),
                  painter: GridPainter(
                    gridSize: gridSize,
                    screenWidth: screenWidth,
                    screenHeight: fixedHeight,
                  ),
                );
              },
            ),
            ...hall.tables.map((table) {
              final key = getTableKey(table);
              final position = tablePositions[key] ?? Offset(0, 0);
              return Positioned(
                left: position.dx + offsetX, // Смещаем вправо
                top: position.dy + offsetY, // Смещаем вниз
                child: Draggable<TableModel>(
                  data: table,
                  feedback: TableWidget(
                    table: table,
                    isDragging: true,
                    onTap: () {},
                  ),
                  childWhenDragging: const SizedBox.shrink(),
                  child: TableWidget(
                    table: table,
                    onTap: () => onTableTap(table),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
