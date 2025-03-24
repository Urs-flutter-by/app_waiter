import '../../data/models/hall_model.dart';
import '../../data/models/shift_status.dart';

abstract class ShiftRepository {
  // checkShift - смена открыта?
  Future<ShiftStatus> checkShift(String waiterId);
  // openShift - открывает смену
  Future<ShiftStatus> openShift(String waiterId, String restaurantId);
  //
  Future<List<HallModel>> getHalls(String restaurantId, String waiterId);
}