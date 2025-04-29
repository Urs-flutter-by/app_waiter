// lib/src/features/menu/data/models/category_model.dart
import 'package:json_annotation/json_annotation.dart';
import 'package:basic_template/src/features/menu/data/models/dish_model.dart';

part 'category_model.g.dart';

@JsonSerializable()
class CategoryModel {
  final String id;
  final String name;
  final List<DishModel> dishes;

  CategoryModel({
    required this.id,
    required this.name,
    required this.dishes,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => _$CategoryModelFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryModelToJson(this);
}