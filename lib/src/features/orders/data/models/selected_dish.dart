// lib/src/features/orders/data/models/selected_dish.dart
import 'package:basic_template/src/features/menu/data/models/dish_model.dart';
import 'package:hive/hive.dart';

part 'selected_dish.g.dart';

@HiveType(typeId: 2) // Уникальный ID для Hive
class SelectedDish {
  @HiveField(0)
  final DishModel dish;
  @HiveField(1)
  final int quantity;

  SelectedDish({
    required this.dish,
    required this.quantity,
  });

  SelectedDish copyWith({DishModel? dish, int? quantity}) {
    return SelectedDish(
      dish: dish ?? this.dish,
      quantity: quantity ?? this.quantity,
    );
  }
}