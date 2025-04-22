import '../../../../core/data/action_repository.dart';
import '../../data/models/order_model.dart';

abstract class OrderRepository implements ActionRepository<OrderModel> {
  Future<OrderModel?> getOrder(String tableId);
  Future<void> confirmOrder(String tableId, String orderId);
  Future<void> completeOrder(String tableId, String orderId);

  @override
  Future<OrderModel?> getItem(String tableId) => getOrder(tableId);
  @override
  Future<void> confirmItem(String tableId, String orderId) => confirmOrder(tableId, orderId);
  @override
  Future<void> completeItem(String tableId, String orderId) => completeOrder(tableId, orderId);
}