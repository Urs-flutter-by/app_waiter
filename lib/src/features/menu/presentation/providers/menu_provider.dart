// lib/src/features/menu/providers/menu_provider.dart
import 'package:basic_template/src/features/menu/data/menu_repository.dart';
import 'package:basic_template/src/features/menu/data/models/category_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/network_provider.dart';

final menuRepositoryProvider = Provider<MenuRepository>((ref) {
  final networkService = ref.read(networkServiceProvider);
  return MenuRepositoryImpl(networkService: networkService);
});

final menuProvider = FutureProvider.family<List<CategoryModel>, String>((ref, restaurantId) async {
  final repository = ref.read(menuRepositoryProvider);
  return await repository.getMenu(restaurantId);
});