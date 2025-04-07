import '../data/models/waiter_request.dart';

abstract class RequestRepository {
  Future<WaiterRequest?> getWaiterRequest(String tableId);
  Future<void> confirmRequest(String tableId, String requestId); // Новый метод
}