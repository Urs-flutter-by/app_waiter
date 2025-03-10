import '../../../../core/data/repositories/base_repository.dart';
import '../../domain/entities/waiter.dart';
import '../../domain/repositories /auth_repository.dart';
import '../models/waiter_model.dart';

// класс реализации авторизации, обращается непосредственно к серверу
class AuthRepositoryImpl extends BaseRepository implements AuthRepository {
  AuthRepositoryImpl({required super.dio});

  @override
  Future<Waiter> signIn(String username, String password, String? restaurantName) async {
    final requestData = {
      'username': username,
      'password': password,
      if (restaurantName != null) 'restaurantName': restaurantName,
    };
    final response = await postRequest('/auth/login', requestData); // Используем метод из BaseRepository
    final waiterModel = WaiterModel.fromJson(response);
    return Waiter(
      id: waiterModel.id,
      username: waiterModel.username,
      restaurantId: waiterModel.restaurantId,
    );
  }
}