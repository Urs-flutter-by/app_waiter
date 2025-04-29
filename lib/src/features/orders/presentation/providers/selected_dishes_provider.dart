// lib/src/features/orders/presentations/providers/selected_dishes_provider.dart
import 'package:basic_template/src/features/menu/data/models/dish_model.dart';
import 'package:basic_template/src/features/orders/data/models/selected_dish.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

final selectedDishesProvider = StateNotifierProvider.family<
    SelectedDishesNotifier, List<SelectedDish>, String>(
  (ref, key) => SelectedDishesNotifier(key),
);

class SelectedDishesNotifier extends StateNotifier<List<SelectedDish>> {
  final String key;
  late Box<List> _box;

  SelectedDishesNotifier(this.key) : super([]) {
    _init();
  }

  Future<void> _init() async {
    _box = await Hive.openBox<List>('selected_dishes');
    _loadDishes();
  }

  void _loadDishes() {
    final savedDishes = _box.get(key, defaultValue: []);
    state = savedDishes?.cast<SelectedDish>().toList() ?? [];
  }

  void addDish(DishModel dish) {
    final currentDishes = [...state];
    final index = currentDishes.indexWhere((item) => item.dish.id == dish.id);

    if (index != -1) {
      currentDishes[index] =
          SelectedDish(dish: dish, quantity: currentDishes[index].quantity + 1);
    } else {
      currentDishes.add(SelectedDish(dish: dish, quantity: 1));
    }

    state = currentDishes;
    _box.put(key, state);
  }

  void removeDish(DishModel dish) {
    final currentDishes = [...state];
    final index = currentDishes.indexWhere((item) => item.dish.id == dish.id);

    if (index != -1 && currentDishes[index].quantity > 0) {
      currentDishes[index] =
          SelectedDish(dish: dish, quantity: currentDishes[index].quantity - 1);
      if (currentDishes[index].quantity == 0) {
        currentDishes.removeAt(index);
      }
    }

    state = currentDishes;
    _box.put(key, state);
  }

  // Новый метод для полной очистки заказов
  void clearDishes() {
    state = [];
    _box.put(key, state);
  }

  @override
  void dispose() {
    _box.close();
    super.dispose();
  }
}
