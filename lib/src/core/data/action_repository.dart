abstract class ActionRepository<T> {
  Future<T?> getItem(String tableId);
  Future<void> confirmItem(String tableId, String itemId);
  Future<void> completeItem(String tableId, String itemId);
}