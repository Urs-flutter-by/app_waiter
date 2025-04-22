// lib/src/features/orders/presentation/providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../data/models/order_model.dart';
import '../../data/repositories/order_repository_impl.dart';
import '../../domain/repositories/order_repository.dart';



final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  return OrderRepositoryImpl(dio: Dio());
});



final orderProvider = FutureProvider.family<OrderModel?, String>((ref, tableId) async {
  final repository = ref.read(orderRepositoryProvider);
  return await repository.getOrder(tableId);
});


