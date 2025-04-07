import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/dio_provider.dart';
import '../../../tables/data/models/hall_model.dart';
import '../../../shift/data/models/shift_status.dart';
import '../../../shift/domain/repositories/shift_repository.dart';
import '../../../shift/presentation/providers/shift_provider.dart';
import '../../../tables/domain/repositories/table_repository.dart';
import '../../../tables/presentation/providers/table_provider.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/waiter.dart';
import '../../domain/repositories /auth_repository.dart';
import '../../domain/usecases/sign_in.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(dio: ref.read(dioProvider));
});

final signInUseCaseProvider = Provider<SignInUseCase>((ref) {
  return SignInUseCase(ref.read(authRepositoryProvider));
});

// диспетчер", который следит за состоянием авторизации (загрузка, успех, ошибка)
// страница LoginScreen "слушает" authProvider
final authProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<AuthState>>((ref) {
  return AuthNotifier(
    ref.read(signInUseCaseProvider),
    ref.read(shiftRepositoryProvider),
    ref.read(tableRepositoryProvider), // Добавили TableRepository
  );
});

// обновляет состояние по нажатию кнопки "Войти"

class AuthNotifier extends StateNotifier<AsyncValue<AuthState>> {
  final SignInUseCase signInUseCase;
  final ShiftRepository shiftRepository;
  final TableRepository tableRepository; // Добавили TableRepository
  bool _hasCheckedShift = false;

  AuthNotifier(this.signInUseCase, this.shiftRepository, this.tableRepository)
      : super(AsyncValue.data(AuthState.initial()));

  Future<void> signIn(
      String username, String password, String restaurantId) async {
    if (state.isLoading) return;
    state = const AsyncValue.loading();
    try {
      final waiter = await signInUseCase(username, password, restaurantId);
      if (!_hasCheckedShift) {
        final shiftStatus = await shiftRepository.checkShift(waiter.id);
        _hasCheckedShift = true;
        state = AsyncValue.data(AuthState.loggedIn(waiter, shiftStatus));
      }
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> openShift(Waiter waiter, String restaurantId) async {
    state = const AsyncValue.loading();
    try {
      final shiftStatus =
          await shiftRepository.openShift(waiter.id, restaurantId);
      state = AsyncValue.data(AuthState.loggedIn(waiter, shiftStatus));
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> loadHalls(Waiter waiter, String restaurantId) async {
    state = const AsyncValue.loading();
    try {
      final currentState = state.value;
      final halls = await tableRepository.getHalls(
          restaurantId, waiter.id); // Используем TableRepository
      final updatedShiftStatus = ShiftStatus(
        success: currentState?.shiftStatus?.success ?? true,
        shiftOpen: currentState?.shiftStatus?.shiftOpen ?? false,
        openedAt: currentState?.shiftStatus?.openedAt,
        halls: halls,
      );
      state = AsyncValue.data(AuthState.loggedIn(waiter, updatedShiftStatus));
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> refreshHalls(Waiter waiter, String restaurantId) async {
    try {
      final currentState = state.value;
      final halls = await tableRepository.getHalls(
          restaurantId, waiter.id); // Используем TableRepository
      final updatedShiftStatus = ShiftStatus(
        success: currentState?.shiftStatus?.success ?? true,
        shiftOpen: currentState?.shiftStatus?.shiftOpen ?? false,
        openedAt: currentState?.shiftStatus?.openedAt,
        halls: halls,
      );
      state = AsyncValue.data(AuthState.loggedIn(waiter, updatedShiftStatus));
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

class AuthState {
  final Waiter? waiter;
  final ShiftStatus? shiftStatus;
  final bool isInitial;
  final List<HallModel>? halls;

  AuthState.initial()
      : waiter = null,
        shiftStatus = null,
        isInitial = true,
        halls = null;

  AuthState.loggedIn(this.waiter, this.shiftStatus)
      : isInitial = false,
        halls = shiftStatus?.halls;

  bool get isShiftOpen => shiftStatus?.shiftOpen ?? false;
  String? get openedAt => shiftStatus?.openedAt;
}
