import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/dio_provider.dart';
import '../../../shift/data/models/shift_status.dart';
import '../../../shift/domain/repositories/shift_repository.dart';
import '../../../shift/presentation/providers/shift_provider.dart';
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
final authProvider = StateNotifierProvider<AuthNotifier, AsyncValue<AuthState>>((ref) {
  return AuthNotifier(
    ref.read(signInUseCaseProvider),
    ref.read(shiftRepositoryProvider),
  );
});

// обновляет состояние по нажатию кнопки "Войти"
class AuthNotifier extends StateNotifier<AsyncValue<AuthState>> {
  final SignInUseCase signInUseCase;
  final ShiftRepository shiftRepository;

  AuthNotifier(this.signInUseCase, this.shiftRepository)
      : super(AsyncValue.data(AuthState.initial()));

  Future<void> signIn(
      String username, String password, String restaurantId) async {
    state = const AsyncValue.loading();
    try {
      final waiter = await signInUseCase(username, password, restaurantId);
      final shiftStatus = await shiftRepository.checkShift(waiter.id);
      state = AsyncValue.data(AuthState.loggedIn(waiter, shiftStatus));
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

class AuthState {
  final Waiter? waiter;
  final ShiftStatus? shiftStatus;
  // Чтобы избежать отображения "Ошибка авторизации" при первичном открытии,
  // нужно различать начальное состояние (до попытки авторизации) и состояние
  // после неудачной авторизации.
  final bool isInitial;


  AuthState.initial()
      : waiter = null,
        shiftStatus = null,
        isInitial = true; // Начальное состояние

  AuthState.loggedIn(this.waiter, this.shiftStatus) : isInitial = false;

  bool get isShiftOpen => shiftStatus?.shiftOpen ?? false;
  String? get openedAt => shiftStatus?.openedAt;
}
