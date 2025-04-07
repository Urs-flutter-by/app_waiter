// lib/src/features/tables/presentation/widgets/request_section.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../requests/presentation/providers/waiter_request_provider.dart';
import '../providers/halls_provider.dart';


class RequestSection extends StatelessWidget {
  final String tableId;
  final bool hasGuestRequest;
  final bool hasInProgressRequest;
  final bool isRequestConfirmed;
  final VoidCallback onRequestConfirmed;

  const RequestSection({
    super.key,
    required this.tableId,
    required this.hasGuestRequest,
    required this.hasInProgressRequest,
    required this.isRequestConfirmed,
    required this.onRequestConfirmed,
  });

  Future<void> _confirmRequest(WidgetRef ref, String requestId) async {
    final repository = ref.read(requestRepositoryProvider);
    try {
      await repository.confirmRequest(tableId, requestId);
      ref.invalidate(waiterRequestProvider(tableId));
      ref.invalidate(hallsStreamProvider);
      ref.read(hallsStreamProvider);
    } catch (e) {
      throw Exception('Failed to confirm request: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!(hasGuestRequest || hasInProgressRequest)) {
      return const SizedBox.shrink();
    }

    return Consumer(
      builder: (context, ref, child) {
        final requestAsync = ref.watch(waiterRequestProvider(tableId));
        return requestAsync.when(
          data: (request) {
            if (request == null) {
              return const Text('Запрос не найден');
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Запрос от гостя:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          request.message,
                          style: const TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Статус: ${request.status}',
                          style: const TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Время: ${request.createdAt.toString()}',
                          style: const TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                if (request.status == 'new')
                  ElevatedButton(
                    onPressed: isRequestConfirmed
                        ? null
                        : () async {
                      try {
                        await _confirmRequest(ref, request.requestId);
                        onRequestConfirmed();
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Ошибка: $e')),
                        );
                      }
                    },
                    child: Text(isRequestConfirmed ? 'Подтверждено' : 'Подтвердить'),
                  ),
                if (request.status == 'in_progress')
                  ElevatedButton(
                    onPressed: () {
                      // Логика для "Исполнено"
                    },
                    child: const Text('Исполнено'),
                  ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Text('Ошибка: $error'),
        );
      },
    );
  }
}