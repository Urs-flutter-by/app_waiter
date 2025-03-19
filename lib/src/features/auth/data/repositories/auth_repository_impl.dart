import '../../../../core/data/repositories/base_repository.dart';
import '../../domain/entities/waiter.dart';
import '../../domain/repositories /auth_repository.dart';
import '../models/waiter_model.dart';

// класс реализации авторизации, обращается непосредственно к серверу
class AuthRepositoryImpl extends BaseRepository implements AuthRepository {
  AuthRepositoryImpl({required super.dio});

  @override
  Future<Waiter> signIn(
      String username, String password, String restaurantId) async {
    final requestData = {
      'username': username,
      'password': password,
      'restaurantId': restaurantId,
    };
    final response = await postRequest('http://localhost:3002/auth/login',
        requestData); // Используем метод из BaseRepository
    //final waiterModel = WaiterModel.fromJson(response);
    final waiterModel = WaiterModel.fromJson(response['waiter']);
    return Waiter(
      id: waiterModel.id,
      username: waiterModel.username,
      restaurantId: waiterModel.restaurantId,
    );
  }
}
