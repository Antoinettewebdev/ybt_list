/// Generic CRUD contract for Firestore-backed repositories.
abstract class CrudRepository<T> {
  Future<T> create(T entity);
  Future<T> getById(String id);
  Future<List<T>> getAll();
  Stream<List<T>> watchAll();
  Future<T> update(String id, T entity);
  Future<void> delete(String id);
}
