// lib/src/features/orders/data/models/dish_model.dart
import 'package:json_annotation/json_annotation.dart';
part 'dish_model.g.dart';

@JsonSerializable()
class DishModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final String weight;
  final List<String>? imageUrls;
  final bool isAvailable;

  DishModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.weight,
    this.imageUrls,
    required this.isAvailable,
  });

  factory DishModel.fromJson(Map<String, dynamic> json) => _$DishModelFromJson(json);
  Map<String, dynamic> toJson() => _$DishModelToJson(this);
}
