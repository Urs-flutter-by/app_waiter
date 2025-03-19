import '../entities/waiter.dart';
import '../repositories /auth_repository.dart';

//организует процесс авторизации, и делегирует задачу "хранилищу" (AuthRepository)
// Страница(LoginScreen) через провайдер вызывает этот класс,
// передавая логин и пароль, а он возвращает Waiter.

class SignInUseCase {
  final AuthRepository repository;

  SignInUseCase(this.repository);

  Future<Waiter> call(String username, String password, String restaurantId) async {
    return await repository.signIn(username, password, restaurantId);
  }
}