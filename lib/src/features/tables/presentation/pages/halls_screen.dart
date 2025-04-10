import 'package:basic_template/src/features/tables/presentation/pages/table_request_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/utils/notification_handler.dart';
import '../../utils.dart';
import '../widgets/halls_tab_bar.dart';
import '../widgets/halls_page_view.dart';
import '../../data/models/hall_model.dart';
import '../providers/halls_provider.dart';


class HallsScreen extends ConsumerStatefulWidget {
  const HallsScreen({super.key});

  @override
  ConsumerState<HallsScreen> createState() => _HallsScreenState();
}

class _HallsScreenState extends ConsumerState<HallsScreen>
    with TickerProviderStateMixin {
  List<HallModel> _halls = [];
  int _currentHallIndex = 0;
  final double _gridSize = 80.0;
  Map<String, Offset> _tablePositions = {};
  final Map<int, GlobalKey> _stackKeys = {};
  Box<Offset>? _positionBox; // Делаем опциональным
  late NotificationHandler _notificationHandler;
  TabController? _tabController;
  late PageController _pageController;
  int _previousHallsLength = 0;
  bool _isLoadingPositions = true; // Флаг для отслеживания загрузки

  @override
  void initState() {
    super.initState();
    _initHiveAndLoadPositions();
    _notificationHandler = NotificationHandler();
    _pageController = PageController(initialPage: _currentHallIndex);
  }

  Future<void> _initHiveAndLoadPositions() async {
    _positionBox = await Hive.openBox<Offset>('table_positions');
    setState(() {
      _tablePositions = _positionBox!.toMap().cast<String, Offset>();
      _isLoadingPositions = false;
    });
  }

  Future<void> _savePosition(String key, Offset position) async {
    if (_positionBox != null) {
      await _positionBox!.put(key, position);
    }
  }

  void _initializeTablePositions(HallModel hall, double screenWidth) {
    if (_isLoadingPositions)
      return; // Не инициализируем, пока не загрузились позиции

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

  void _updateTabController(int newLength) {
    if (_tabController == null || _tabController!.length != newLength) {
      _tabController?.dispose();
      _tabController = TabController(
        length: newLength,
        vsync: this,
        initialIndex: _currentHallIndex.clamp(0, newLength - 1),
      );
      _tabController!.addListener(() {
        if (_tabController!.index != _currentHallIndex) {
          setState(() {
            _currentHallIndex = _tabController!.index;
            _pageController.jumpToPage(_currentHallIndex);
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _notificationHandler.dispose();
    _tabController?.dispose();
    _pageController.dispose();
    super.dispose();
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
            if (_previousHallsLength != halls.length) {
              _updateTabController(halls.length);
              _previousHallsLength = halls.length;
            }
            return HallsTabBar(
              tabController: _tabController,
              halls: halls,
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

          _notificationHandler.checkForNewNotifications(halls);

          _halls = halls;
          for (var hall in _halls) {
            _initializeTablePositions(hall, screenWidth);
          }

          return HallsPageView(
            halls: halls,
            gridSize: _gridSize,
            screenWidth: screenWidth,
            fixedHeight: fixedHeight,
            tablePositions: _tablePositions,
            stackKeys: _stackKeys,
            pageController: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentHallIndex = index;
                _tabController?.animateTo(index);
              });
            },
            onPositionChanged: (tableId, newPosition) {
              final key = getTableKey(
                  halls[_currentHallIndex],
                  halls[_currentHallIndex]
                      .tables
                      .firstWhere((t) => t.tableId == tableId));
              setState(() {
                _tablePositions[key] = newPosition;
              });
              _savePosition(key, newPosition);
            },
            onTableTap: (table) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TableRequestScreen(table: table),
                ),
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