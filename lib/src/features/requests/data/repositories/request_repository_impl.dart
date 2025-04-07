// lib/src/features/requests/data/repositories/request_repository_impl.dart
import '../../../../core/data/repositories/base_repository.dart';
import '../../domain/request_repository_.dart';
import '../models/waiter_request.dart';

class RequestRepositoryImpl extends BaseRepository
    implements RequestRepository {
  RequestRepositoryImpl({required super.dio});

  @override
  Future<WaiterRequest?> getWaiterRequest(String tableId) async {
    try {
      final response = await getRequest(
        'http://localhost:3002/requests?tableId=$tableId',
      );

      if (response['success'] != true || response['request'] == null) {
        return null;
      }
      final request = WaiterRequest.fromJson(response['request']);

      return request;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> confirmRequest(String tableId, String requestId) async {
    try {
      final requestData = {
        'tableId': tableId,
        'requestId': requestId,
      };
      final response = await postRequest(
          'http://localhost:3002/requests/confirm', requestData);
      if (response['success'] != true) {
        throw Exception(response['message'] ?? 'Failed to confirm request');
      }
    } catch (e) {
      throw Exception('Failed to confirm request: $e');
    }
  }
}
