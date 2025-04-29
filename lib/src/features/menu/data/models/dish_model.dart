// lib/src/features/orders/data/models/dish_model.dart
// lib/src/features/menu/data/models/dish_model.dart
import 'package:json_annotation/json_annotation.dart';
import 'package:hive/hive.dart';
part 'dish_model.g.dart';

@HiveType(typeId: 1) // Уникальный ID для Hive
@JsonSerializable()
class DishModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final double price;

  @HiveField(4)
  final String weight;

  @HiveField(5)
  @JsonKey(name: 'imageUrl')
  final List<String>? imageUrls;

  @HiveField(6)
  @JsonKey(defaultValue: true)
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