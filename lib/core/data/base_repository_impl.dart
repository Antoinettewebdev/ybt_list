import '../domain/crud_repository.dart';
import '../errors/failures.dart';
import '../utils/exception_mapper.dart';
import 'base_firestore_data_source.dart';

abstract class BaseRepositoryImpl<T> implements CrudRepository<T> {
  BaseRepositoryImpl(this._dataSource);

  final BaseFirestoreDataSource<T> _dataSource;

  Failure _mapError(Object e) => ExceptionMapper.toFailure(e);

  @override
  Future<T> create(T entity) async {
    try {
      return await _dataSource.create(entity);
    } catch (e) {
      throw _mapError(e);
    }
  }

  @override
  Future<T> getById(String id) async {
    try {
      return await _dataSource.getById(id);
    } catch (e) {
      throw _mapError(e);
    }
  }

  @override
  Future<List<T>> getAll() async {
    try {
      return await _dataSource.getAll();
    } catch (e) {
      throw _mapError(e);
    }
  }

  @override
  Stream<List<T>> watchAll() => _dataSource.watchAll().handleError(
        (Object e, StackTrace _) {
          throw _mapError(e);
        },
      );

  @override
  Future<T> update(String id, T entity) async {
    try {
      return await _dataSource.update(id, entity);
    } catch (e) {
      throw _mapError(e);
    }
  }

  @override
  Future<void> delete(String id) async {
    try {
      await _dataSource.delete(id);
    } catch (e) {
      throw _mapError(e);
    }
  }
}
