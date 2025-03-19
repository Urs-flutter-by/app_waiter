import 'package:json_annotation/json_annotation.dart';
part 'waiter_model.g.dart';

// Модель идентификации Официанта для общения с сервером (формат JSON)
@JsonSerializable()
class WaiterModel {
  final String id;
  final String username;
  final String restaurantId;

  WaiterModel({
    required this.id,
    required this.username,
    required this.restaurantId,
  });

  factory WaiterModel.fromJson(Map<String, dynamic> json) => _$WaiterModelFromJson(json);
  Map<String, dynamic> toJson() => _$WaiterModelToJson(this);
}