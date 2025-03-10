import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/dio_provider.dart';
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
    StateNotifierProvider<AuthNotifier, AsyncValue<Waiter?>>((ref) {
  return AuthNotifier(ref.read(signInUseCaseProvider));
});


// обновляет состояние по нажатию кнопки "Войти"
class AuthNotifier extends StateNotifier<AsyncValue<Waiter?>> {
  final SignInUseCase signInUseCase;

  AuthNotifier(this.signInUseCase) : super(const AsyncValue.data(null));

  Future<void> signIn(
      String username, String password, String? restaurantName) async {
    state = const AsyncValue.loading();
    try {
      final waiter = await signInUseCase(username, password, restaurantName);
      state = AsyncValue.data(waiter);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}
