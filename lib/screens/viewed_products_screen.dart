import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewedProductsScreen extends StatefulWidget {
  @override
  _ViewedProductsScreenState createState() => _ViewedProductsScreenState();
}

class _ViewedProductsScreenState extends State<ViewedProductsScreen> {
  late List<dynamic> _viewedProducts = [];

  @override
  void initState() {
    super.initState();
    _loadViewedProducts();
  }

  // Cargar los productos vistos desde SharedPreferences
  Future<void> _loadViewedProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final viewedData = prefs.getString('viewed_products') ?? '[]';
    setState(() {
      _viewedProducts = jsonDecode(viewedData);
    });
  }

  // Navegar al detalle del producto
  void _navigateToProductDetail(int productId) {
    // Aquí puedes agregar la navegación al detalle del producto
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => ProductDetailScreen(productId: productId),
    //   ),
    // );
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Navegando a los detalles del producto $productId'),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Productos Vistos')),
      body: _viewedProducts.isEmpty
          ? const Center(child: Text('No has visto ningún producto.'))
          : ListView.builder(
              itemCount: _viewedProducts.length,
              itemBuilder: (context, index) {
                final product = _viewedProducts[index];
                return ListTile(
                  title: Text(product['name']),
                  subtitle: Text('\$${product['price']}'),
                  trailing: Text('Visto ${product['viewCount']} veces'),
                  onTap: () => _navigateToProductDetail(product['productId']),
                );
              },
            ),
    );
  }
}
