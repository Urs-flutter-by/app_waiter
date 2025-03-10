
import 'repositories/base_repository.dart'; // Импортируем BaseRepository


// класс для выполнения HTTP-запросов через Dio
class NetworkService extends BaseRepository {
  NetworkService({required super.dio});

  // Дополнительные методы для работы с API (если нужно)
  Future<Map<String, dynamic>> fetchSomeData(String url) async {
    return getRequest(url); // Используем метод из BaseRepository
  }

  Future<void> sendData(String url, Map<String, dynamic> data) async {
    await postRequest(url, data); // Используем метод из BaseRepository
  }
}