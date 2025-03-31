import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../data/repositories/table_repository_impl.dart';
import '../../domain/repositories/table_repository.dart';


final tableRepositoryProvider = Provider<TableRepository>((ref) {
  return TableRepositoryImpl(dio: Dio());
});