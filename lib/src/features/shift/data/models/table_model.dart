import 'package:json_annotation/json_annotation.dart';

part 'table_model.g.dart';

@JsonSerializable()
class TableModel {
  final String tableId;
  final String status; // "free", "occupied", "reserved"
  final bool isOwn;
  final bool hasNewOrder;
  final bool hasGuestRequest;

  TableModel({
    required this.tableId,
    required this.status,
    required this.isOwn,
    required this.hasNewOrder,
    required this.hasGuestRequest,
  });

  factory TableModel.fromJson(Map<String, dynamic> json) => _$TableModelFromJson(json);
  Map<String, dynamic> toJson() => _$TableModelToJson(this);
}