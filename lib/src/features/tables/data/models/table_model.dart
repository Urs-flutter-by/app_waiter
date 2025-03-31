import 'package:json_annotation/json_annotation.dart';
part 'table_model.g.dart';

@JsonSerializable()
class TableModel {
  final String tableId;
  final String status; // "free", "occupied", "reserved"
  final bool isOwn;
  final bool hasNewOrder;
  final bool hasGuestRequest;

  // для позиционирования
  // double x; // Позиция по X
  // double y; // Позиция по Y

  TableModel({
    required this.tableId,
    required this.status,
    required this.isOwn,
    required this.hasNewOrder,
    required this.hasGuestRequest,
    // Начальная позиция
    // this.x = 0.0,
    // this.y = 0.0,
  });

  factory TableModel.fromJson(Map<String, dynamic> json) {
    return TableModel(
      tableId: json['tableId'],
      status: json['status'],
      isOwn: json['isOwn'],
      hasNewOrder: json['hasNewOrder'],
      hasGuestRequest: json['hasGuestRequest'],
      // x: json['x']?.toDouble() ?? 0.0,
      // y: json['y']?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tableId': tableId,
      'status': status,
      'isOwn': isOwn,
      'hasNewOrder': hasNewOrder,
      'hasGuestRequest': hasGuestRequest,
      // 'x': x,
      // 'y': y,
    };
  }
}