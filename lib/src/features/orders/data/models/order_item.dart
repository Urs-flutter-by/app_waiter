// lib/src/features/orders/data/models/order_item.dart
import 'package:json_annotation/json_annotation.dart';
import '../../../menu/data/models/dish_model.dart';


part 'order_item.g.dart';

@JsonSerializable()
class OrderItem {
  final String dishId;
  final int quantity;
  final DishModel dish;
  final String status;
  @JsonKey(fromJson: _nullableDateTimeFromJson, toJson: _nullableDateTimeToJson)
  final DateTime? createdAt; // Сделали опциональным
  @JsonKey(fromJson: _nullableDateTimeFromJson, toJson: _nullableDateTimeToJson)
  final DateTime? confirmedAt;
  @JsonKey(fromJson: _nullableDateTimeFromJson, toJson: _nullableDateTimeToJson)
  final DateTime? completedAt;

  OrderItem({
    required this.dishId,
    required this.quantity,
    required this.dish,
    required this.status,
    this.createdAt,
    this.confirmedAt,
    this.completedAt,
  });

  double get totalPrice => dish.price * quantity;

  factory OrderItem.fromJson(Map<String, dynamic> json) => _$OrderItemFromJson(json);
  Map<String, dynamic> toJson() => _$OrderItemToJson(this);

  static DateTime? _nullableDateTimeFromJson(String? timestamp) =>
      timestamp == null || timestamp.isEmpty ? null : DateTime.parse(timestamp);
  static String? _nullableDateTimeToJson(DateTime? timestamp) =>
      timestamp?.toIso8601String();
}