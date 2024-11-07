import '../infraestructure/connection/api_service.dart';



class ProductRepository {
  final ApiService _apiService = ApiService();

  Future<List<String>> getProductsByCategory(String category) async {
    return await _apiService.getProductsByCategory(category);
  }
}
