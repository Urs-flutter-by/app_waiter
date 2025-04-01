// lib/src/features/tables/presentation/widgets/halls_tab_bar.dart
import 'package:flutter/material.dart';
import '../../data/models/hall_model.dart';

// класс отвечает за отображение вкладок залов
class HallsTabBar extends StatelessWidget {
  final TabController? tabController;
  final List<HallModel> halls;

  const HallsTabBar({
    super.key,
    required this.tabController,
    required this.halls,
  });

  int _countNotifications(HallModel hall) {
    return hall.tables.where((table) => table.hasNewOrder || table.hasGuestRequest).length;
  }

  @override
  Widget build(BuildContext context) {
    if (halls.isEmpty) return const Text('Залы');

    return TabBar(
      controller: tabController,
      isScrollable: true,
      labelColor: Colors.black,
      unselectedLabelColor: Colors.grey,
      //indicatorColor: Colors.white,
      labelStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
      unselectedLabelStyle: const TextStyle(fontSize: 16),
      tabs: halls.map((hall) {
        final notificationCount = _countNotifications(hall);
        return Tab(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(hall.name),
              if (notificationCount > 0) ...[
                const SizedBox(width: 8),
                Icon(Icons.notifications_active, color: Colors.red, size: 20),
                const SizedBox(width: 4),
                Text(
                  '$notificationCount',
                  style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
              ],
            ],
          ),
        );
      }).toList(),
    );
  }
}