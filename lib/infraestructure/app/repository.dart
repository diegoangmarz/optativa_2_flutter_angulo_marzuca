import '../connection/api_service.dart';

abstract class IRepository<T> {
  Future<List<T>> getAll();
  Future<T> getById(int id);
  Future<void> create(T entity);
  Future<void> update(T entity);
  Future<void> delete(int id);
}

class ProductRepository implements IRepository<String> {
  final ApiService _apiService = ApiService();

  @override
  Future<List<String>> getAll() async {
    return await _apiService.getCategories();
  }

  @override
  Future<String> getById(int id) async {
    return "Product $id";
  }

  @override
  Future<void> create(String entity) async {}

  @override
  Future<void> update(String entity) async {}

  @override
  Future<void> delete(int id) async {}
}
