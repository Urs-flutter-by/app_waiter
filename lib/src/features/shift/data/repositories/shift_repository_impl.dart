import '../../../../core/data/repositories/base_repository.dart';
import '../../domain/repositories/shift_repository.dart';
import '../models/hall_model.dart';
import '../models/shift_status.dart';

class ShiftRepositoryImpl extends BaseRepository implements ShiftRepository {
  ShiftRepositoryImpl({required super.dio});

  @override
  Future<ShiftStatus> checkShift(String waiterId) async {
    final response = await postRequest(
        'http://localhost:3002/shift/check', {'waiterId': waiterId});
    return ShiftStatus.fromJson(response);
  }

  @override
  Future<ShiftStatus> openShift(String waiterId, String restaurantId) async {
    final response = await postRequest(
      'http://localhost:3002/shift/open',
      {
        'waiterId': waiterId,
        'restaurantId': restaurantId,
      },
    );
    return ShiftStatus.fromJson(response);
  }

  @override
  Future<List<HallModel>> getHalls(String restaurantId, String waiterId) async {
    final response = await getRequest(
      'http://localhost:3002/halls?restaurantId=$restaurantId&waiterId=$waiterId',
    );
    return (response['halls'] as List)
        .map((hall) => HallModel.fromJson(hall))
        .toList();
  }

}
