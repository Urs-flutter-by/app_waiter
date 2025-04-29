// lib/src/features/menu/data/menu_repository.dart
import 'package:basic_template/src/features/menu/data/models/category_model.dart';
import '../../../core/data/network_service.dart';

abstract class MenuRepository {
  Future<List<CategoryModel>> getMenu(String restaurantId);
}

class MenuRepositoryImpl implements MenuRepository {
  final NetworkService networkService;

  MenuRepositoryImpl({required this.networkService});

  @override
  Future<List<CategoryModel>> getMenu(String restaurantId) async {
    // Выполняем GET-запрос к эндпоинту /menu
    final response = await networkService
        .getRequest('http://localhost:3002//menu?restaurantId=$restaurantId');



    // Извлекаем массив categories
    final categoriesJson = response['categories'] as List<dynamic>;
    return categoriesJson.map((json) => CategoryModel.fromJson(json)).toList();
  }
}
