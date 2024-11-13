import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../routes.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key});

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  Map<String, dynamic>? product;
  bool isLoading = true;
  bool isAdding = false;
  int quantity = 1;
  int cartItemCount = 0;
  int totalQuantityInCart = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchProductDetails();
      fetchCartDetails();
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

  Future<void> fetchCartDetails() async {
    final prefs = await SharedPreferences.getInstance();
    final carts = prefs.getStringList('carts') ?? [];
    setState(() {
      cartItemCount = carts.length;
      totalQuantityInCart = carts
          .map((e) => json.decode(e)['quantity'] as int)
          .fold(0, (previousValue, element) => previousValue + element);
    });
  }

  void _incrementQuantity() {
    setState(() {
      if (quantity < (product?['stock'] ?? 0)) {
        quantity++;
      }
    });
  }

  void _decrementQuantity() {
    setState(() {
      if (quantity > 0) {
        quantity--;
      }
    });
  }

  void _addToCart() async {
    if (quantity <= 0 || quantity > (product?['stock'] ?? 0)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('La cantidad no es válida')),
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
      existingCart['total'] = existingCart['price'] * existingCart['quantity'];
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
        'thumbnail': product?['thumbnail'], 
      }));
    }

    await prefs.setStringList('carts', carts);
    await fetchCartDetails();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Producto añadido al carrito.')),
    );

    setState(() {
      isAdding = false;
      quantity = 1; 
    });
  }

  Future<bool> _onWillPop() async {
    if (isAdding) {
      setState(() {
        isAdding = false;
      });
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isOutOfStock = product?['stock'] == 0;
    final isCartFull = cartItemCount >= 7;
    final isStockInCart = totalQuantityInCart >= (product?['stock'] ?? 0);

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Detalle del Producto'),
          backgroundColor: Colors.blue,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            PopupMenuButton<String>(
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
          ],
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
                          child: isOutOfStock || isCartFull || isStockInCart
                              ? const Text(
                                  'Producto agotado',
                                  style: TextStyle(color: Colors.red, fontSize: 18.0),
                                )
                              : isAdding
                                  ? Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.remove),
                                          onPressed: _decrementQuantity,
                                        ),
                                        Text(
                                          '$quantity',
                                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.add),
                                          onPressed: _incrementQuantity,
                                        ),
                                        const SizedBox(width: 20),
                                        ElevatedButton(
                                          onPressed: quantity > 0 ? _addToCart : null,
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: quantity > 0 ? Colors.blue : Colors.grey,
                                            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                                            textStyle: const TextStyle(color: Colors.white),
                                          ),
                                          child: const Text(
                                            'Añadir',
                                            style: TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    )
                                  : ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue,
                                        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                                        textStyle: const TextStyle(color: Colors.white),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          isAdding = true;
                                        });
                                      },
                                      child: const Text(
                                        '+ Agregar',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }
}
