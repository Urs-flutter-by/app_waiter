import '../../../core/data/action_repository.dart';
import '../data/models/waiter_request.dart';

abstract class RequestRepository implements ActionRepository<WaiterRequest> {
  Future<WaiterRequest?> getWaiterRequest(String tableId);
  Future<void> confirmRequest(String tableId, String requestId);
  Future<void> completeRequest(String tableId, String requestId);

  @override
  Future<WaiterRequest?> getItem(String tableId) => getWaiterRequest(tableId);
  @override
  Future<void> confirmItem(String tableId, String requestId) => confirmRequest(tableId, requestId);
  @override
  Future<void> completeItem(String tableId, String requestId) => completeRequest(tableId, requestId);
}