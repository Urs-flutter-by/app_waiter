import '../../../../core/data/repositories/base_repository.dart';
import '../../domain/repositories/shift_repository.dart';
import '../models/shift_status.dart';

class ShiftRepositoryImpl extends BaseRepository implements ShiftRepository {
  ShiftRepositoryImpl({required super.dio});

  @override
  Future<ShiftStatus> checkShift(String waiterId) async {
    try {
      final response = await postRequest(
        'http://localhost:3002/shift/check',
        {'waiterId': waiterId},
      );
      return ShiftStatus.fromJson(response);
    } catch (e) {
      throw Exception('Failed to check shift: $e');
    }
  }

  @override
  Future<ShiftStatus> openShift(String waiterId, String restaurantId) async {
    try {
      final response = await postRequest(
        'http://localhost:3002/shift/open',
        {
          'waiterId': waiterId,
          'restaurantId': restaurantId,
        },
      );
      return ShiftStatus.fromJson(response);
    } catch (e) {
      throw Exception('Failed to open shift: $e');
    }
  }
}
