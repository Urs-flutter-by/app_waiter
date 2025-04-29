// lib/src/features/orders/presentations/providers/selected_dishes_provider.dart
import 'package:basic_template/src/features/menu/data/models/dish_model.dart';
import 'package:basic_template/src/features/orders/data/models/selected_dish.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

class SelectedDishesNotifier extends StateNotifier<List<SelectedDish>> {
  final String hiveKey;
  Box<List>? _box;

  SelectedDishesNotifier(this.hiveKey) : super([]) {
    _initHive();
  }

  Future<void> _initHive() async {
    _box = await Hive.openBox<List>('selected_dishes');
    final savedDishes = _box!.get(hiveKey, defaultValue: []);
    state = savedDishes?.cast<SelectedDish>() ?? [];
  }

  Future<void> _saveToHive() async {
    if (_box != null) {
      await _box!.put(hiveKey, state);
    }
  }

  void addDish(DishModel dish) {
    final existingIndex = state.indexWhere((item) => item.dish.id == dish.id);
    if (existingIndex >= 0) {
      state = [
        ...state.sublist(0, existingIndex),
        state[existingIndex]
            .copyWith(quantity: state[existingIndex].quantity + 1),
        ...state.sublist(existingIndex + 1),
      ];
    } else {
      state = [...state, SelectedDish(dish: dish, quantity: 1)];
    }
    _saveToHive();
    // print('Updated selected dishes: $state');
  }

  void removeDish(DishModel dish) {
    final existingIndex = state.indexWhere((item) => item.dish.id == dish.id);
    if (existingIndex >= 0) {
      final currentQuantity = state[existingIndex].quantity;
      if (currentQuantity <= 1) {
        state = [
          ...state.sublist(0, existingIndex),
          ...state.sublist(existingIndex + 1),
        ];
      } else {
        state = [
          ...state.sublist(0, existingIndex),
          state[existingIndex].copyWith(quantity: currentQuantity - 1),
          ...state.sublist(existingIndex + 1),
        ];
      }
      _saveToHive();
      // print('Updated selected dishes: $state');
    }
  }

  void clear() {
    state = [];
    _saveToHive();
  }
}

final selectedDishesProvider = StateNotifierProvider.family<
    SelectedDishesNotifier, List<SelectedDish>, String>(
  (ref, key) => SelectedDishesNotifier(key),
);
