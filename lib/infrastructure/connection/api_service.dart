import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../../infrastructure/connection/api_service.dart';

class ApiService {
  static const String baseUrl = 'https://dummyjson.com';

  // Función para obtener categorías de productos
  Future<List<dynamic>> fetchCategories() async {
    final response = await http.get(Uri.parse('$baseUrl/products/categories'));
    if (response.statusCode == 200) {
      return json.decode(response.body);  // Devuelve las categorías
    } else {
      throw Exception('Error loading categories');
    }
  }

  // Función para obtener productos por categoría
  Future<List<dynamic>> fetchProductsByCategory(String category) async {
    final response = await http.get(Uri.parse('$baseUrl/products/category/$category'));
    if (response.statusCode == 200) {
      return json.decode(response.body)['products'];  // Devuelve los productos de la categoría
    } else {
      throw Exception('Error loading products in category');
    }
  }

  // Función para obtener detalles de un producto
  Future<Map<String, dynamic>> fetchProductDetail(int productId) async {
    final response = await http.get(Uri.parse('$baseUrl/products/$productId'));
    if (response.statusCode == 200) {
      return json.decode(response.body);  // Devuelve los detalles del producto
    } else {
      throw Exception('Error loading product details');
    }
  }

  // Función para realizar búsqueda de productos
  Future<List<Map<String, dynamic>>> searchProducts(String query) async {
    final response = await http.get(Uri.parse('$baseUrl/products/search?q=$query'));
    if (response.statusCode == 200) {
      // Devuelve la lista de productos como una lista de mapas
      return List<Map<String, dynamic>>.from(json.decode(response.body)['products']);
    } else {
      throw Exception('Error searching products');
    }
  }
}
