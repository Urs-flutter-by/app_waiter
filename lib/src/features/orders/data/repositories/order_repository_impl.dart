// lib/src/features/orders/data/repositories/order_repository.dart

import '../../../../core/data/repositories/base_repository.dart';
import '../../domain/repositories/order_repository.dart';
import '../models/order_model.dart';

// Логика для подтверждения всего заказа не отдельных блюд

class OrderRepositoryImpl extends BaseRepository implements OrderRepository {
  OrderRepositoryImpl({required super.dio});

  @override
  Future<OrderModel?> getOrder(String tableId) async {
    try {
      final response = await getRequest(
        'http://localhost:3002/orders?tableId=$tableId',
      );
      if (response['success'] != true || response['order'] == null) {
        return null;
      }
      final order = OrderModel.fromJson(response['order']);
      return order;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> confirmOrder(String tableId, String orderId) async {
    try {
      final requestData = {
        'tableId': tableId,
        'orderId': orderId,
        'confirmedAt': DateTime.now().toIso8601String(),
      };
      final response = await postRequest(
          'http://localhost:3002/orders/confirm', requestData);
      if (response['success'] != true) {
        throw Exception(response['message'] ?? 'Failed to confirm order');
      }
    } catch (e) {
      throw Exception('Failed to confirm order: $e');
    }
  }

  @override
  Future<void> completeOrder(String tableId, String orderId) async {
    try {
      final requestData = {
        'tableId': tableId,
        'orderId': orderId,
        'completedAt': DateTime.now().toIso8601String(),
      };
      final response = await postRequest(
        'http://localhost:3002/orders/complete',
        requestData,
      );
      if (response['success'] != true) {
        throw Exception(response['message'] ?? 'Failed to complete order');
      }
    } catch (e) {
      throw Exception('Error completing order: $e');
    }
  }

  // Добавляем недостающие методы из ActionRepository
  @override
  Future<OrderModel?> getItem(String tableId) => getOrder(tableId);

  @override
  Future<void> confirmItem(String tableId, String orderId) => confirmOrder(tableId, orderId);

  @override
  Future<void> completeItem(String tableId, String orderId) => completeOrder(tableId, orderId);
}