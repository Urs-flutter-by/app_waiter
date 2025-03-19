import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/dio_provider.dart';
import '../../data/repositories/shift_repository_impl.dart';
import '../../domain/repositories/shift_repository.dart';

final shiftRepositoryProvider = Provider<ShiftRepository>((ref) {
  return ShiftRepositoryImpl(dio: ref.read(dioProvider));
});