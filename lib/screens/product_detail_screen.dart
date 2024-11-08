import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cart_model.dart';
import '../widgets/add_to_cart_dialog.dart';
import '../routes.dart'; 

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key});

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  Map<String, dynamic>? product;
  bool isLoading = true;
  final TextEditingController _quantityController = TextEditingController();

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
    final quantity = int.tryParse(_quantityController.text) ?? 0;
    if (quantity <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, ingrese una cantidad válida')),
      );
      return;
    }

    if (quantity > (product?['stock'] ?? 0)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('La cantidad no puede superar el stock disponible')),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final carts = prefs.getStringList('carts') ?? [];
    final productId = product?['id'].toString() ?? '';

    final existingCartIndex = carts.indexWhere((element) => json.decode(element)['id'] == productId);
    if (existingCartIndex != -1) {
      final existingCart = json.decode(carts[existingCartIndex]);
      existingCart['quantity'] += quantity;
      carts[existingCartIndex] = json.encode(existingCart);
    } else {
      if (carts.length >= 7) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No puede agregar más de 7 productos diferentes al carrito')),
        );
        return;
      }

      carts.add(json.encode({
        'id': productId,
        'name': product?['title'],
        'price': product?['price'],
        'quantity': quantity,
        'total': (product?['price'] ?? 0) * quantity,
        'date': DateTime.now().toString(),
      }));
    }

    await prefs.setStringList('carts', carts);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Producto añadido al carrito.')),
    );
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
                      TextField(
                        controller: _quantityController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Cantidad',
                          border: OutlineInputBorder(),
                        ),
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
