// lib/src/features/requests/presentation/providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../data/models/waiter_request.dart';
import '../../data/repositories/request_repository_impl.dart';
import '../../domain/request_repository_.dart';

final requestRepositoryProvider = Provider<RequestRepository>((ref) {
  return RequestRepositoryImpl(dio: Dio());
});

final waiterRequestProvider =
    FutureProvider.family<WaiterRequest?, String>((ref, tableId) async {
  final repository = ref.read(requestRepositoryProvider);
  return await repository.getWaiterRequest(tableId);
});
