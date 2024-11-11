import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../routes.dart';

class CartsScreen extends StatefulWidget {
  const CartsScreen({super.key});

  @override
  CartsScreenState createState() => CartsScreenState();
}

class CartsScreenState extends State<CartsScreen> {
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

  void updateCartItems() async {
    final prefs = await SharedPreferences.getInstance();
    final carts = cartItems.map((item) => json.encode(item)).toList();
    await prefs.setStringList('carts', carts);
    setState(() {});
  }

  void removeItem(int index) {
    setState(() {
      cartItems.removeAt(index);
    });
    updateCartItems();
  }

  void incrementQuantity(int index) {
    setState(() {
      cartItems[index]['quantity']++;
      cartItems[index]['total'] = cartItems[index]['price'] * cartItems[index]['quantity'];
    });
    updateCartItems();
  }

  void decrementQuantity(int index) {
    setState(() {
      if (cartItems[index]['quantity'] > 1) {
        cartItems[index]['quantity']--;
        cartItems[index]['total'] = cartItems[index]['price'] * cartItems[index]['quantity'];
      } else {
        removeItem(index);
      }
    });
    updateCartItems();
  }

  void addItemToCart(Map<String, dynamic> item) async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    item['dateAdded'] = now.toString();

    cartItems.add(item);
    updateCartItems();
  }

  @override
  Widget build(BuildContext context) {
    final totalSum = cartItems.fold(
      0.0,
      (previousValue, item) => previousValue + item['total'],
    );

    final totalQuantity = cartItems.fold<int>(
      0,
      (previousValue, item) => previousValue + (item['quantity'] as int),
    );

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Carrito'),
            Text(
              'Total: \$${totalSum.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
        backgroundColor: Colors.blue,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : cartItems.isEmpty
              ? const Center(child: Text('No hay productos en el carrito'))
              : ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    final item = cartItems[index];
                    return Card(
                      elevation: 5,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 100,
                                  height: 100,
                                  child: Image.network(
                                    item['thumbnail'] ?? 'https://via.placeholder.com/150',
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(Icons.image, color: Colors.grey);
                                    },
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(item['name'] ?? 'Producto desconocido', style: const TextStyle(fontWeight: FontWeight.bold)),
                                      const SizedBox(height: 8),
                                      Text('Precio por unidad: \$${item['price'].toStringAsFixed(2)}'), // Añadir precio por unidad
                                      Text('Total: \$${item['total'].toStringAsFixed(2)}'),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.info, color: Colors.blue),
                                  onPressed: () {
                                    Navigator.pushNamed(
                                      context,
                                      Routes.productDetail,
                                      arguments: item['id'].toString(),
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => removeItem(index),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove),
                                  onPressed: () => decrementQuantity(index),
                                ),
                                Text('${item['quantity']}'),
                                IconButton(
                                  icon: const Icon(Icons.add),
                                  onPressed: () => incrementQuantity(index),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
