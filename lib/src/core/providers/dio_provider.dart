import 'package:basic_template/src/app/constants/error_messages.dart';
import 'package:basic_template/src/core/utils/logger.dart';
import 'package:dio/dio.dart';
import 'package:riverpod/riverpod.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio();

  // Добавляем интерцептор для логирования запросов
  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) {
      AppLogger.logInfo('Sending request to ${options.uri}');
      return handler.next(options);
    },
    onResponse: (response, handler) {
      AppLogger.logInfo('Received response with status ${response.statusCode}');
      return handler.next(response);
    },
    onError: (e, handler) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.connectionError) {
        AppLogger.logError(ErrorMessages.internetError, e.message, e.stackTrace);
        handler.reject(DioException(
            requestOptions: e.requestOptions,
            message: 'No internet connection'));
      } else {
        AppLogger.logError(ErrorMessages.dioError, e.message, e.stackTrace);
        handler.next(e);
      }
    },
  ));

  return dio;
});
