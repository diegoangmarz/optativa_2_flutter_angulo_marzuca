import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  CategoriesScreenState createState() => CategoriesScreenState();
}

class CategoriesScreenState extends State<CategoriesScreen> {
  List<Map<String, dynamic>> categories = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      final response = await http
          .get(Uri.parse('https://dummyjson.com/products/categories'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('API Response: $data');
        if (data is List) {
          setState(() {
            categories = List<Map<String, dynamic>>.from(data
                .map((item) => {'name': item['name'], 'slug': item['slug']}));
            isLoading = false;
          });
        } else {
          throw Exception('Unexpected data format');
        }
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (error) {
      setState(() {
        errorMessage = 'Error fetching categories: $error';
        isLoading = false;
      });
    }
  }

// Método para guardar el producto visitado, con su nombre, precio y contador de visitas.
  Future<void> _saveViewedProduct(Map<String, dynamic> product) async {
    final prefs = await SharedPreferences.getInstance();
    final visitedProductsList = prefs.getStringList('visitedProducts') ?? [];

    final productId = product['id'];
    final productName = product['name'];
    final productPrice = product['price'];

    bool productFound = false;
    for (int i = 0; i < visitedProductsList.length; i++) {
      final item = visitedProductsList[i];
      final splitItem = item.split('|');

      // Verifica si el producto ya está en la lista
      if (splitItem[0] == productId) {
        final visitCount = int.parse(splitItem[3]) + 1;
        visitedProductsList[i] =
            '$productId|$productName|$productPrice|$visitCount';
        productFound = true;
        break;
      }
    }

    // Si el producto no está en la lista, lo agrega con el contador de visitas inicializado en 1
    if (!productFound) {
      final newProduct = '$productId|$productName|$productPrice|1';
      visitedProductsList.add(newProduct);
    }

    // Guarda la lista actualizada de productos visitados
    await prefs.setStringList('visitedProducts', visitedProductsList);
  }
}
