// lib/src/features/tables/presentation/pages/notification_handler.dart

import 'package:audioplayers/audioplayers.dart';
import '../../features/tables/data/models/hall_model.dart';
import '../../features/tables/data/models/table_model.dart';

//класс, который отвечает за звуковые оповещения и отслеживание уведомлений
class NotificationHandler {
  final AudioPlayer _audioPlayer = AudioPlayer();
  Map<String, bool> _previousNotifications = {};

  NotificationHandler() {
    _preloadSound();
  }

  // метод предзагрузки bell.mp3
  Future<void> _preloadSound() async {
    try {
      await _audioPlayer.setSource(AssetSource('sounds/bell.mp3'));
    } catch (e) {
      //print('Error preloading sound: $e');
    }
  }

  Future<void> _playSound() async {
    try {
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource('sounds/bell.mp3'));
    } catch (e) {
      //print('Error playing sound: $e');
    }
  }

  // метод возвращает ID стола зал+стол исключаем дублирования ID столов
  String getTableKey(HallModel hall, TableModel table) {
    return '${hall.hallId}_${table.tableId}';
  }

  void checkForNewNotifications(List<HallModel> halls) {
    Map<String, bool> currentNotifications = {};
    for (var hall in halls) {
      for (var table in hall.tables) {
        final key = getTableKey(hall, table);
        currentNotifications[key] = table.hasNewOrder || table.hasGuestRequest;
      }
    }

    for (var entry in currentNotifications.entries) {
      final key = entry.key;
      final hasNotification = entry.value;
      final previousHasNotification = _previousNotifications[key] ?? false;

      if (!previousHasNotification && hasNotification) {
        _playSound();
      }
    }

    _previousNotifications = currentNotifications;
  }

  void dispose() {
    _audioPlayer.dispose();
  }
}
