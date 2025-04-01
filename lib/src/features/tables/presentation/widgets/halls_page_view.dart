// lib/src/features/tables/presentation/widgets/halls_page_view.dart
import 'package:flutter/material.dart';
import '../../data/models/hall_model.dart';
import '../../data/models/table_model.dart';
import 'hall_view.dart';

//класс содержит PageView.builder и логику переключения страниц
class HallsPageView extends StatelessWidget {
  final List<HallModel> halls;
  final double gridSize;
  final double screenWidth;
  final double fixedHeight;
  final Map<String, Offset> tablePositions;
  final Map<int, GlobalKey> stackKeys;
  final PageController pageController;
  final ValueChanged<int> onPageChanged;
  final Function(String, Offset) onPositionChanged;

  const HallsPageView({
    super.key,
    required this.halls,
    required this.gridSize,
    required this.screenWidth,
    required this.fixedHeight,
    required this.tablePositions,
    required this.stackKeys,
    required this.pageController,
    required this.onPageChanged,
    required this.onPositionChanged,
  });

  String getTableKey(HallModel hall, TableModel table) {
    return '${hall.hallId}_${table.tableId}';
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: pageController,
      onPageChanged: onPageChanged,
      itemCount: halls.length,
      itemBuilder: (context, index) {
        final hall = halls[index];
        if (!stackKeys.containsKey(index)) {
          stackKeys[index] = GlobalKey();
        }

        return HallView(
          hall: hall,
          gridSize: gridSize,
          screenWidth: screenWidth,
          fixedHeight: fixedHeight,
          tablePositions: tablePositions,
          stackKey: stackKeys[index]!,
          onPositionChanged: onPositionChanged,
        );
      },
    );
  }
}