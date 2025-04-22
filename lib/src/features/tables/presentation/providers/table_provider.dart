import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../data/repositories/table_repository_impl.dart';
import '../../domain/repositories/table_repository.dart';



final tableRepositoryProvider = Provider<TableRepository>((ref) {
  return TableRepositoryImpl(dio: Dio());
});



// final tableProvider = StreamProvider.autoDispose.family<TableModel?, String>((ref, tableId) {
//   return ref.watch(hallsStreamProvider).map((hallsAsync) {
//     // Безопасно обрабатываем состояние загрузки или ошибки
//     if (hallsAsync.hasError || !hallsAsync.hasValue) {
//       return null;
//     }
//     final halls = hallsAsync.value ?? [];
//     return halls.expand((hall) => hall.tables).firstWhere(
//           (table) => table.tableId == tableId,
//       orElse: () => null,
//     );
//   });
// });