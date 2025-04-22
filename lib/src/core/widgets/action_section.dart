// lib/src/core/widgets/action_section.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:basic_template/src/core/data/action_repository.dart';
import 'package:basic_template/src/core/data/json_serializable.dart';
import '../../features/tables/presentation/providers/halls_provider.dart';

class ActionSection<T extends ToJsonSerializable> extends StatefulWidget {
  final String tableId;
  final bool hasNewItem;
  final bool hasInProgressItem;
  final bool isConfirmed;
  final VoidCallback onConfirmed;
  final String title;
  final String itemIdField; // Название поля для ID (orderId или requestId)
  final ProviderBase<AsyncValue<T?>> provider;
  final ActionRepository<T> repository;
  final Widget Function(T) itemBuilder;

  const ActionSection({
    super.key,
    required this.tableId,
    required this.hasNewItem,
    required this.hasInProgressItem,
    required this.isConfirmed,
    required this.onConfirmed,
    required this.title,
    required this.itemIdField,
    required this.provider,
    required this.repository,
    required this.itemBuilder,
  });

  @override
  _ActionSectionState<T> createState() => _ActionSectionState<T>();
}


class _ActionSectionState<T extends ToJsonSerializable>
    extends State<ActionSection<T>> {
  bool _isLoading = false;
  bool _isCompleted = false;

  Future<void> _confirmItem(WidgetRef ref, T item) async {
    setState(() => _isLoading = true);
    try {
      final itemId = item.toJson()[widget.itemIdField] as String;

      await widget.repository.confirmItem(widget.tableId, itemId);

      ref.invalidate(widget.provider);
      ref.invalidate(hallsStreamProvider);
      widget.onConfirmed();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${widget.title} подтвержден')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Ошибка при подтверждении ${widget.title.toLowerCase()}: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _completeItem(WidgetRef ref, T item) async {
    setState(() => _isLoading = true);
    try {
      final itemId = item.toJson()[widget.itemIdField] as String;

      await widget.repository.completeItem(widget.tableId, itemId);
      ref.invalidate(widget.provider);
      ref.invalidate(hallsStreamProvider);
      setState(() => _isCompleted = true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${widget.title} выполнен ')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Ошибка при выполнении ${widget.title.toLowerCase()}: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!(widget.hasNewItem || widget.hasInProgressItem)) {
      return const SizedBox.shrink();
    }

    return Consumer(
      builder: (context, ref, child) {
        final itemAsync = ref.watch(widget.provider);
        return itemAsync.when(
          data: (item) {
            if (item == null) {
              return Text('${widget.title} не найден');
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.hasNewItem
                      ? 'Новый ${widget.title.toLowerCase()}'
                      : '${widget.title} в процессе',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                widget.itemBuilder(item),
                const SizedBox(height: 16),
                if (widget.hasNewItem && !widget.isConfirmed)
                  ElevatedButton(
                    onPressed: _isLoading
                        ? null
                        : () async => await _confirmItem(ref, item),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Подтвердить'),
                  ),
                if (widget.isConfirmed && widget.hasNewItem)
                  const ElevatedButton(
                    onPressed: null,
                    child: Text('Подтверждено'),
                  ),
                if (widget.hasInProgressItem &&
                    !widget.isConfirmed &&
                    !_isCompleted)
                  ElevatedButton(
                    onPressed: _isLoading
                        ? null
                        : () async => await _completeItem(ref, item),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Исполнено'),
                  ),
                if (_isCompleted)
                  const ElevatedButton(
                    onPressed: null,
                    child: Text('Выполнено'),
                  ),
              ],
            );
          },
          loading: () {
            return const Center(child: CircularProgressIndicator());
          },
          error: (error, stack) {
            return Text('Ошибка: $error');
          },
        );
      },
    );
  }
}
