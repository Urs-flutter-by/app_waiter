import '../../data/models/order_model.dart';

abstract class OrderRepository {
  Future<OrderModel?> getOrder(String tableId);
  Future<void> confirmOrder(String tableId, String orderId);
}