import 'package:dio/dio.dart';
import '../../../../core/data/repositories/base_repository.dart';
import '../../data/models/hall_model.dart';
import '../../domain/repositories/table_repository.dart';

class TableRepositoryImpl extends BaseRepository implements TableRepository {
  TableRepositoryImpl({required super.dio});

  @override
  Future<List<HallModel>> getHalls(String restaurantId, String waiterId) async {
    try {
      final response = await getRequest(
        'http://localhost:3002/halls?restaurantId=$restaurantId&waiterId=$waiterId',
      );
      if (response['success'] != true) {
        throw Exception(response['message'] ?? 'Failed to load halls');
      }
      return (response['halls'] as List)
          .map((hall) => HallModel.fromJson(hall))
          .toList();
    } catch (e) {
      if (e is DioException && e.response != null) {
        throw Exception(
            'Failed to load halls: ${e.response?.statusCode} - ${e.response?.data}');
      }
      throw Exception('Failed to load halls: $e');
    }
  }
}