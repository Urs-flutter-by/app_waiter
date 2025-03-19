import '../../data/models/shift_status.dart';

abstract class ShiftRepository {
  Future<ShiftStatus> checkShift(String waiterId);
}