import '../../../../core/data/repositories/base_repository.dart';
import '../../domain/repositories/shift_repository.dart';
import '../models/shift_status.dart';

class ShiftRepositoryImpl extends BaseRepository implements ShiftRepository {
  ShiftRepositoryImpl({required super.dio});

  @override
  Future<ShiftStatus> checkShift(String waiterId) async {
    final response = await postRequest(
        'http://localhost:3002/shift/check', {'waiterId': waiterId});
    return ShiftStatus.fromJson(response);
  }
}
