import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../routes.dart';

class CartsScreen extends StatefulWidget {
  const CartsScreen({super.key});

  @override
  _CartsScreenState createState() => _CartsScreenState();
}

class _CartsScreenState extends State<CartsScreen> {
  List<Map<String, dynamic>> cartItems = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCartItems();
  }

  Future<void> fetchCartItems() async {
    final prefs = await SharedPreferences.getInstance();
    final carts = prefs.getStringList('carts') ?? [];

    setState(() {
      cartItems = List<Map<String, dynamic>>.from(
        carts.map((item) => json.decode(item)),
      );
      isLoading = false;
    });
  }

  void _removeItem(int index) async {
    final prefs = await SharedPreferences.getInstance();
    cartItems.removeAt(index);
    final carts = cartItems.map((item) => json.encode(item)).toList();
    await prefs.setStringList('carts', carts);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final totalSum = cartItems.fold(
      0.0,
      (previousValue, item) => previousValue + item['total'],
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Carrito de Compras (\$${totalSum.toStringAsFixed(2)})'),
        backgroundColor: Colors.blue,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : cartItems.isEmpty
              ? const Center(child: Text('No hay productos en el carrito'))
              : ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    final item = cartItems[index];
                    return Card(
                      elevation: 5,
                      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: ListTile(
                        leading: Image.network(
                          item['thumbnail'] ?? '',
                          fit: BoxFit.cover,
                          width: 50,
                          height: 50,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.image, color: Colors.grey);
                          },
                        ),
                        title: Text(item['name'] ?? 'Producto desconocido'),
                        subtitle: Text('Cantidad: ${item['quantity']} - Total: \$${item['total'].toStringAsFixed(2)}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _removeItem(index),
                        ),
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            Routes.productDetail,
                            arguments: item['id'].toString(),
                          );
                        },
                      ),
                    );
                  },
                ),
    );
  }
}
