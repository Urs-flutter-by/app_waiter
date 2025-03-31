// import 'dart:convert';
// import 'dart:ui'; // Для Offset
// import 'package:shared_preferences/shared_preferences.dart';

// class TablePositionStorage {
//   static const String _positionsKey = 'table_positions';
//
//   Future<void> saveTablePositions(Map<String, Offset> positions) async {
//     final prefs = await SharedPreferences.getInstance();
//     final positionList = positions.entries
//         .map((entry) => {
//       'tableId': entry.key,
//       'x': entry.value.dx,
//       'y': entry.value.dy,
//     })
//         .toList();
//     final result = await prefs.setString(_positionsKey, jsonEncode(positionList));
//     //print('Saved to SharedPreferences: $result, Data: $positionList');
//   }
//
//   Future<Map<String, Offset>> loadTablePositions() async {
//     final prefs = await SharedPreferences.getInstance();
//     print('All keys in SharedPreferences: ${prefs.getKeys()}');
//     final positionsString = prefs.getString(_positionsKey);
//
//     print('Raw positions from SharedPreferences: $positionsString');
//     if (positionsString == null || positionsString.isEmpty) {
//       print('No positions found in SharedPreferences');
//       return {};
//     }
//     try {
//       final positionList = List<Map<String, dynamic>>.from(jsonDecode(positionsString));
//       final positions = {
//         for (var pos in positionList)
//           pos['tableId'] as String: Offset(
//             (pos['x'] as num).toDouble(),
//             (pos['y'] as num).toDouble(),
//           ),
//       };
//       print('Loaded positions: $positions');
//       return positions;
//     } catch (e) {
//       print('Error decoding positions: $e');
//       return {};
//     }
//   }
//
//   // Метод для очистки данных (для отладки)
//   Future<void> clearPositions() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove(_positionsKey);
//     print('Cleared SharedPreferences');
//   }
// }