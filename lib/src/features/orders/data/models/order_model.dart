// lib/src/features/orders/data/models/order_model.dart
import 'package:json_annotation/json_annotation.dart';
import 'order_item.dart';
part 'order_model.g.dart';

@JsonSerializable()
class OrderModel {
  final String orderId;
  final List<OrderItem> items;

  OrderModel({
    required this.orderId,
    required this.items,
  });

  double get totalCost => items.fold(0, (sum, item) => sum + item.totalPrice);

  factory OrderModel.fromJson(Map<String, dynamic> json) => _$OrderModelFromJson(json);
  Map<String, dynamic> toJson() => _$OrderModelToJson(this);
}