import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../data/models/hall_model.dart';
import '../../data/models/table_model.dart';
import '../providers/halls_provider.dart';
import '../widgets/hall_view.dart';

class HallsScreen extends ConsumerStatefulWidget {
  const HallsScreen({super.key});

  @override
  ConsumerState<HallsScreen> createState() => _HallsScreenState();
}

class _HallsScreenState extends ConsumerState<HallsScreen> {
  List<HallModel> _halls = [];
  int _currentHallIndex = 0;
  final double _gridSize = 80.0;
  Map<String, Offset> _tablePositions = {};
  final Map<int, GlobalKey> _stackKeys = {};
  late Box<Offset> _positionBox;

  @override
  void initState() {
    super.initState();
    _initHiveAndLoadPositions();
  }

  Future<void> _initHiveAndLoadPositions() async {
    _positionBox = await Hive.openBox<Offset>('table_positions');
    setState(() {
      _tablePositions = _positionBox.toMap().cast<String, Offset>();
    });
  }

  Future<void> _savePosition(String key, Offset position) async {
    await _positionBox.put(key, position);
  }

  String getTableKey(HallModel hall, TableModel table) {
    return '${hall.hallId}_${table.tableId}';
  }

  void _initializeTablePositions(HallModel hall, double screenWidth) {
    final columns = (screenWidth / _gridSize).floor();
    int row = 0;
    int col = 0;

    for (final table in hall.tables) {
      final key = getTableKey(hall, table);
      if (!_tablePositions.containsKey(key) ||
          _tablePositions[key] == Offset(0, 0)) {
        double newX = col * _gridSize;
        double newY = row * _gridSize;

        _tablePositions[key] = Offset(newX, newY);
        _savePosition(key, _tablePositions[key]!);

        col++;
        if (col >= columns) {
          col = 0;
          row++;
        }
      }
    }
  }

  int _countNotifications(HallModel hall) {
    return hall.tables
        .where((table) => table.hasNewOrder || table.hasGuestRequest)
        .length;
  }

  @override
  Widget build(BuildContext context) {
    final hallsStream = ref.watch(hallsStreamProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final fixedHeight = screenHeight * 3;

    return Scaffold(
      appBar: AppBar(
        title: hallsStream.when(
          data: (halls) {
            if (halls.isEmpty) return const Text('Залы');
            final hall = halls[_currentHallIndex];
            final notificationCount = _countNotifications(hall);
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(hall.name),
                if (notificationCount > 0) ...[
                  const SizedBox(width: 8),
                  Icon(Icons.notifications_active, color: Colors.red, size: 20),
                  const SizedBox(width: 4),
                  Text(
                    '$notificationCount',
                    style: const TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                ],
              ],
            );
          },
          loading: () => const Text('Залы'),
          error: (error, stack) => const Text('Залы'),
        ),
      ),
      body: hallsStream.when(
        data: (halls) {
          if (halls.isEmpty) {
            return const Center(child: Text('Залы не загружены'));
          }

          _halls = halls;
          for (var hall in _halls) {
            _initializeTablePositions(hall, screenWidth);
          }

          return PageView.builder(
            onPageChanged: (index) => setState(() => _currentHallIndex = index),
            itemCount: halls.length,
            itemBuilder: (context, index) {
              final hall = halls[index];
              if (!_stackKeys.containsKey(index)) {
                _stackKeys[index] = GlobalKey();
              }

              return HallView(
                hall: hall,
                gridSize: _gridSize,
                screenWidth: screenWidth,
                fixedHeight: fixedHeight,
                tablePositions: _tablePositions,
                stackKey: _stackKeys[index]!,
                onPositionChanged: (tableId, newPosition) {
                  final key = getTableKey(hall,
                      hall.tables.firstWhere((t) => t.tableId == tableId));
                  setState(() {
                    _tablePositions[key] = newPosition;
                  });
                  _savePosition(key, newPosition);
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Ошибка: $error')),
      ),
    );
  }
}
