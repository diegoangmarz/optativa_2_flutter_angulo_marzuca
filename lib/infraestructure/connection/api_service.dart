import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String _baseUrl = 'https://dummyjson.com';

  Future<String?> login(String username, String password) async {
    final url = Uri.parse('$_baseUrl/auth/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['token'];
    } else {
      print('Login fallido: ${response.body}');
      return null;
    }
  }

  Future<List<String>> getCategories() async {
    final url = Uri.parse('$_baseUrl/products/categories');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.cast<String>();
    } else {
      throw Exception('Error al obtener las categorías');
    }
  }

  Future<List<String>> getProductsByCategory(String category) async {
    final url = Uri.parse('$_baseUrl/products/category/$category');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['products'] as List;
      return data.map((product) => product['title'] as String).toList();
    } else {
      throw Exception('Error al obtener productos de la categoría $category');
    }
  }
}
