// lib/src/features/tables/utils.dart
import 'data/models/hall_model.dart';
import 'data/models/table_model.dart';

String getTableKey(HallModel hall, TableModel table) {
  return '${hall.hallId}_${table.tableId}';
}