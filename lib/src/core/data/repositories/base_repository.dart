import 'package:dio/dio.dart';
import 'package:basic_template/src/app/constants/error_messages.dart';

abstract class BaseRepository {
  final Dio dio;

  BaseRepository({required this.dio});

  // Общий метод для выполнения GET-запросов
  Future<Map<String, dynamic>> getRequest(String url) async {
    return _processResponse(
      () async => dio.get(url),
      ErrorMessages.failedLoadData, // Используем константу
    );
  }

  // Общий метод для выполнения POST-запросов
  Future<Map<String, dynamic>> postRequest(
      String url, Map<String, dynamic> data) async {
    return _processResponse(
      () async => dio.post(url, data: data),
      ErrorMessages.failedSendData,
    );
  }

  // Общий метод для выполнения PUT-запросов
  Future<Map<String, dynamic>> putRequest(
      String url, Map<String, dynamic> data) async {
    return _processResponse(
      () async => dio.put(url, data: data),
      ErrorMessages.failedUpdateData,
    );
  }

  // Общий метод для выполнения DELETE-запросов
  Future<Map<String, dynamic>> deleteRequest(String url) async {
    return _processResponse(
      () async => dio.delete(url),
      ErrorMessages.failedDeleteData,
    );
  }

  // Универсальный метод для обработки ответов
  Future<Map<String, dynamic>> _processResponse(
    Future<Response> Function() requestFunction,
    String errorMessage,
  ) async {
    try {
      final response = await requestFunction();
      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        return response.data as Map<String, dynamic>;
      } else {
        throw Exception(errorMessage);
      }
    } catch (error) {
      throw Exception('$ErrorMessages.requestError: $error');
    }
  }
}


