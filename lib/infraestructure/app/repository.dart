import '../connection/api_service.dart';
class Repository {
  final ApiService apiService;

  Repository({required this.apiService});

  Future<List<String>> getCategories() async {
    try {
      final data = await apiService.fetchData('products/categories');
      return List<String>.from(data['categories']);
    } catch (e) {
      throw Exception('Error fetching categories: $e');
    }
  }

  Future<List<String>> getProductsByCategory(String category) async {
    try {
      final data = await apiService.fetchData('products/category/$category');
      return List<String>.from(data['products'].map((item) => item['name'] as String));
    } catch (e) {
      throw Exception('Error fetching products for category $category: $e');
    }
  }

  Future<Map<String, dynamic>> getProductById(String productId) async {
    try {
      final data = await apiService.fetchData('products/$productId');
      return data;
    } catch (e) {
      throw Exception('Error fetching product details: $e');
    }
  }
}
