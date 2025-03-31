import '../../data/models/hall_model.dart';

abstract class TableRepository {
  Future<List<HallModel>> getHalls(String restaurantId, String waiterId);
}