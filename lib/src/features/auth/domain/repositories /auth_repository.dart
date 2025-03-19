import '../entities/waiter.dart';

// интерфейс для работы с авторизацией
// описывает правила договора
// возвращает объект Waiter
// SignInUseCase - обращается к этому интерфейсу
abstract class AuthRepository {
  Future<Waiter> signIn(
      String username, String password, String restaurantId);
}
