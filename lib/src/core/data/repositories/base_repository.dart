import 'package:dio/dio.dart';
import 'package:basic_template/src/app/constants/error_messages.dart';
import '../../utils/logger.dart';

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
        AppLogger.logError('HTTP error: $errorMessage', response.statusCode);
        throw Exception(errorMessage);
      }
    } on DioException catch (e) {
      // Логируем ошибку Dio
      AppLogger.logError(
        'Dio error: ${ErrorMessages.requestError}',
        e.message,
        e.stackTrace,
      );

      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.connectionError) {
        throw Exception(ErrorMessages.internetError,);
      }

      rethrow;
    } catch (error, stackTrace) {
      // Логируем другие ошибки
      AppLogger.logError(
        'Unexpected error: ${ErrorMessages.requestError}',
        error,
        stackTrace,
      );

      throw Exception('$ErrorMessages.requestError: $error');
    }
  }
}