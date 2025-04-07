// lib/src/features/orders/data/repositories/order_repository.dart
import '../../../../core/data/repositories/base_repository.dart';
import '../../domain/repositories/order_repository.dart';
import '../models/order_model.dart';

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
}
