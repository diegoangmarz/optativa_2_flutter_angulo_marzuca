import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({Key? key}) : super(key: key);

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  Map<String, dynamic>? product;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProductDetails();
  }

  Future<void> fetchProductDetails() async {
    final productId = ModalRoute.of(context)?.settings.arguments as String?;
    if (productId != null) {
      final response = await http.get(Uri.parse('https://dummyjson.com/products/$productId'));
      if (response.statusCode == 200) {
        setState(() {
          product = json.decode(response.body);
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load product details');
      }
    } else {
      setState(() {
        isLoading = false;
      });
      throw Exception('Product ID is null');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalle del Producto'),
        backgroundColor: Colors.blue,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : product == null
              ? Center(child: Text('No se encontró información del producto.'))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Image.network(
                          product?['thumbnail'] ?? 'https://via.placeholder.com/150',
                          height: 200,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        product?['title'] ?? 'Nombre del Producto',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Text(
                        product?['description'] ?? 'Descripción del Producto',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Precio: \$${product?['price']}',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Stock: ${product?['stock']}',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                          ),
                          onPressed: () {
                            // Lógica para agregar el producto al carrito
                          },
                          child: Text('+ Agregar'),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
