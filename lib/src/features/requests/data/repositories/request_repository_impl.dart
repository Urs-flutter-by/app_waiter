// lib/src/features/requests/data/repositories/request_repository_impl.dart

import '../../../../core/data/repositories/base_repository.dart';
import '../../domain/request_repository.dart';
import '../models/waiter_request.dart';


class RequestRepositoryImpl extends BaseRepository implements RequestRepository {
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
        'confirmedAt': DateTime.now().toIso8601String(),
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

  @override
  Future<void> completeRequest(String tableId, String requestId) async {
    try {
      final requestData = {
        'tableId': tableId,
        'requestId': requestId,
        'completedAt': DateTime.now().toIso8601String(),
      };
      final response = await postRequest(
        'http://localhost:3002/requests/complete',
        requestData,
      );
      if (response['success'] != true) {
        throw Exception(response['message'] ?? 'Failed to complete request');
      }
    } catch (e) {
      throw Exception('Error completing request: $e');
    }
  }

  // Добавляем недостающие методы из ActionRepository
  @override
  Future<WaiterRequest?> getItem(String tableId) => getWaiterRequest(tableId);

  @override
  Future<void> confirmItem(String tableId, String requestId) => confirmRequest(tableId, requestId);

  @override
  Future<void> completeItem(String tableId, String requestId) => completeRequest(tableId, requestId);
}