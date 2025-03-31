import '../../data/models/shift_status.dart';

abstract class ShiftRepository {
  // checkShift - смена открыта?
  Future<ShiftStatus> checkShift(String waiterId);
  // openShift - открывает смену
  Future<ShiftStatus> openShift(String waiterId, String restaurantId);

}