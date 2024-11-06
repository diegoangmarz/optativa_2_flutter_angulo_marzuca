// lib/repository.dart
import '../infraestructure/connection/api_service.dart';

class Repository {
  final ApiService _apiService = ApiService();

  Future<List<String>> getCategories() async {
    // Aquí deberías hacer una llamada a la API para obtener las categorías
    return ['Categoría 1', 'Categoría 2'];
  }

  Future<List<String>> getProducts(String category) async {
    // Aquí deberías hacer una llamada a la API para obtener los productos de una categoría
    return ['Producto 1', 'Producto 2'];
  }
}

