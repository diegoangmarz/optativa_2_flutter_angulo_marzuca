import '../dto/product_dto.dart';

import '../../../../infrastructure/connection/api_service.dart';

abstract class ProductRepository {
  Future<List<ProductDTO>> fetchProductsByCategory(String category);
  Future<List<ProductDTO>> searchProducts(String query); // Nuevo método
}

class ProductRepositoryImpl implements ProductRepository {
  final ApiService apiService;

  ProductRepositoryImpl({required this.apiService});

  @override
  Future<List<ProductDTO>> fetchProductsByCategory(String category) async {
    final response = await apiService.fetchProductsByCategory(category);
    // Asegurarse de que la respuesta sea una lista y convertirla a ProductDTO
    return response.map<ProductDTO>((json) => ProductDTO.fromJson(json)).toList();
  }

  @override
  Future<List<ProductDTO>> searchProducts(String query) async {
    final response = await apiService.searchProducts(query);
    // Convertir la respuesta de cada producto a ProductDTO
    return response.map<ProductDTO>((json) {
      return ProductDTO.fromJson(Map<String, dynamic>.from(json));
    }).toList();
  }
}
