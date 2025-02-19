import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';

/// AsyncValueWidget для работы с AsyncValue данными из API
/// Это универсальный виджет типа T
class AsyncValueWidget<T> extends StatelessWidget {
  const AsyncValueWidget({
    super.key,
    required this.value,
    required this.data,
  });

  /// Ввод AsyncValue
  final AsyncValue<T> value;

  /// Функция построения выходных данных
  final Widget Function(T) data;

  @override
  Widget build(BuildContext context) {
    return value.when(
      data: data,
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(
        child: Text(
          'Error: $err',
          style: TextStyle(color: Colors.red),
        ),
      ),
    );
  }
}