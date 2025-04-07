import 'package:json_annotation/json_annotation.dart';
part 'table_model.g.dart';

@JsonSerializable()
class TableModel {
  final String tableId;
  final String status; // "free", "occupied", "reserved"
  final bool isOwn;
  final bool hasNewOrder;
  final bool hasGuestRequest;
  final bool hasInProgressOrder; // Новое поле
  final bool hasInProgressRequest; // Новое поле
  final int capacity;

  TableModel({
    required this.tableId,
    required this.status,
    required this.isOwn,
    required this.hasNewOrder,
    required this.hasGuestRequest,
    required this.hasInProgressOrder,
    required this.hasInProgressRequest,
    required this.capacity,
  });

  factory TableModel.fromJson(Map<String, dynamic> json) => _$TableModelFromJson(json);
  Map<String, dynamic> toJson() => _$TableModelToJson(this);
}

