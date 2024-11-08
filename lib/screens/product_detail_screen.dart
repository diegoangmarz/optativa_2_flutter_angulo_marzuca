import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/cart_model.dart';
import '../widgets/add_to_cart_dialog.dart';
import '../routes.dart'; // Asegúrate de importar las rutas

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key});

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  Map<String, dynamic>? product;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchProductDetails();
    });
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
        debugPrint('Product ID is null');
      });
    }
  }

  void _addToCart() async {
    final response = await http.get(Uri.parse('https://dummyjson.com/carts'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<Cart> carts = List<Cart>.from(data['carts'].map((item) => Cart.fromJson(item)));

      final selectedCartId = await showDialog<int>(
        context: context,
        builder: (context) => AddToCartDialog(carts: carts),
      );

      if (selectedCartId != null) {
        final productId = product?['id'];
        if (productId != null) {
          final response = await http.put(
            Uri.parse('https://dummyjson.com/carts/$selectedCartId'),
            headers: { 'Content-Type': 'application/json' },
            body: json.encode({
              'merge': true,
              'products': [
                {
                  'id': productId,
                  'quantity': 1,
                },
              ],
            }),
          );

          if (response.statusCode == 200) {
            final updatedCart = json.decode(response.body);
            debugPrint('Product added to cart: $updatedCart');
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Producto añadido al carrito.')),
              );
            }
          } else {
            debugPrint('Failed to add product to cart. Status code: ${response.statusCode}');
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle del Producto'),
        backgroundColor: Colors.blue,
        leading: PopupMenuButton<String>(
          icon: const Icon(Icons.menu),
          onSelected: (value) {
            if (value == 'Categorías') {
              Navigator.pushNamed(context, Routes.categories);
            } else if (value == 'Carritos') {
              Navigator.pushNamed(context, Routes.carts);
            }
          },
          itemBuilder: (BuildContext context) {
            return {'Categorías', 'Carritos'}.map((String choice) {
              return PopupMenuItem<String>(
                value: choice,
                child: Text(choice),
              );
            }).toList();
          },
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : product == null
              ? const Center(child: Text('No se encontró información del producto.'))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Image.network(
                          product?['thumbnail'] ?? 'https://via.placeholder.com/150',
                          height: 200,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.image, size: 100, color: Colors.grey);
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        product?['title'] ?? 'Nombre del Producto',
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        product?['description'] ?? 'Descripción del Producto',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Precio: \$${product?['price']}',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Stock: ${product?['stock']}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                          ),
                          onPressed: _addToCart,
                          child: const Text('+ Agregar'),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
