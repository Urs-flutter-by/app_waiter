// lib/src/features/tables/presentations/pages/add_guest_order_screen.dart
import 'dart:convert'; // Для работы с JSON
import 'package:basic_template/src/features/menu/data/models/category_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/bootstrap.dart';
import '../../../menu/presentation/providers/menu_provider.dart';
import '../../../orders/data/models/selected_dish.dart';
import '../../../orders/presentation/providers/selected_dishes_provider.dart';

class AddGuestOrderScreen extends ConsumerStatefulWidget {
  final String tableId;
  final int guestIndex;

  const AddGuestOrderScreen({
    super.key,
    required this.tableId,
    required this.guestIndex,
  });

  @override
  ConsumerState<AddGuestOrderScreen> createState() =>
      _AddGuestOrderScreenState();
}

class _AddGuestOrderScreenState extends ConsumerState<AddGuestOrderScreen> {
  List<CategoryModel> _categories = [];
  String _restaurantId = 'rest_12345';

  List<CategoryModel> _sortCategories(List<CategoryModel> categories) {
    // Получаем JSON-строку из Hive
    final savedOrderJson =
        categoryOrderBox.get(_restaurantId, defaultValue: '[]');
    // Декодируем JSON-строку в List<String>
    final savedOrder = List<String>.from(jsonDecode(savedOrderJson!));

    if (savedOrder.isEmpty) {
      return categories;
    }

    // Сортируем категории согласно сохранённому порядку
    final orderedCategories = <CategoryModel>[];
    final remainingCategories = List<CategoryModel>.from(categories);

    for (final categoryId in savedOrder) {
      final index =
          remainingCategories.indexWhere((cat) => cat.id == categoryId);
      if (index != -1) {
        orderedCategories.add(remainingCategories[index]);
        remainingCategories.removeAt(index);
      }
    }

    orderedCategories.addAll(remainingCategories);
    return orderedCategories;
  }

  Future<void> _saveCategoryOrder(List<CategoryModel> categories) async {
    final order = categories.map((cat) => cat.id).toList();
    // Кодируем List<String> в JSON-строку
    final orderJson = jsonEncode(order);

    await categoryOrderBox.put(_restaurantId, orderJson);
  }

  @override
  Widget build(BuildContext context) {
    final guestNumber = widget.guestIndex + 1;
    final tableNumber = widget.tableId.replaceAll('table_', '');
    final menuAsync = ref.watch(menuProvider(_restaurantId));
    final selectedDishesKey = '${widget.tableId}_${widget.guestIndex}';
    final selectedDishes = ref.watch(selectedDishesProvider(selectedDishesKey));

    return Scaffold(
      appBar: AppBar(
        title: Text('Заказ для гостя $guestNumber, стол №$tableNumber'),
      ),
      body: menuAsync.when(
        data: (categories) {
          if (categories.isEmpty) {
            return const Center(child: Text('Меню не загружено'));
          }

          // Сортируем категории согласно сохранённому порядку
          _categories = _sortCategories(categories);

          return ReorderableListView.builder(
            itemCount: _categories.length,
            onReorder: (oldIndex, newIndex) {
              setState(() {
                if (newIndex > oldIndex) {
                  newIndex -= 1;
                }
                final category = _categories.removeAt(oldIndex);
                _categories.insert(newIndex, category);

                // Сохраняем новый порядок
                _saveCategoryOrder(_categories);
              });
            },
            itemBuilder: (context, index) {
              final category = _categories[index];
              return ExpansionTile(
                key: ValueKey(category.id),
                leading: const Icon(Icons.restaurant_menu),
                title: Text(
                  category.name,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                trailing: const Icon(Icons.drag_handle),
                children: category.dishes.map((dish) {
                  final selectedDish = selectedDishes.firstWhere(
                    (item) => item.dish.id == dish.id,
                    orElse: () => SelectedDish(dish: dish, quantity: 0),
                  );
                  final quantity = selectedDish.quantity;

                  return Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: ListTile(
                      leading: const Icon(Icons.fastfood, size: 20),
                      title: Text(dish.name),
                      subtitle: Text('${dish.price} \$ • ${dish.weight}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: dish.isAvailable
                                ? () {
                                    ref
                                        .read(selectedDishesProvider(
                                                selectedDishesKey)
                                            .notifier)
                                        .removeDish(dish);
                                  }
                                : null,
                            icon: const Icon(Icons.remove,
                                color: Colors.white, size: 16),
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: const CircleBorder(),
                              minimumSize: const Size(32, 32),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              '$quantity',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                          IconButton(
                            onPressed: dish.isAvailable
                                ? () {
                                    ref
                                        .read(selectedDishesProvider(
                                                selectedDishesKey)
                                            .notifier)
                                        .addDish(dish);
                                  }
                                : null,
                            icon: const Icon(Icons.add,
                                color: Colors.white, size: 16),
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: const CircleBorder(),
                              minimumSize: const Size(32, 32),
                            ),
                          ),
                        ],
                      ),
                      enabled: dish.isAvailable,
                    ),
                  );
                }).toList(),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Ошибка: $error')),
      ),
    );
  }
}
