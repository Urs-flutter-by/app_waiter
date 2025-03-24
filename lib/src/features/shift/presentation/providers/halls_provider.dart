import 'package:basic_template/src/features/shift/presentation/providers/shift_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/models/hall_model.dart';

final hallsStreamProvider = StreamProvider.autoDispose<List<HallModel>>((ref) async* {
  final authState = ref.watch(authProvider).valueOrNull;
  if (authState == null || authState.waiter == null) {
    yield [];
    return;
  }

  final shiftRepository = ref.read(shiftRepositoryProvider);
  while (true) {
    try {
      final halls = await shiftRepository.getHalls('rest_12345', authState.waiter!.id);
      yield halls;
    } catch (e) {
      yield [];
    }
    await Future.delayed(const Duration(seconds: 10)); // Обновляем каждые 10 секунд
  }
});