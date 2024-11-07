import 'package:flutter/material.dart';
import '../routes.dart';

class ProductsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final category = ModalRoute.of(context)?.settings.arguments as String? ?? 'Categoría desconocida';

    final products = [
      {'name': 'Product 1', 'image': 'assets/images/product1.jpeg'},
      {'name': 'Product 2', 'image': 'assets/images/product2.jpeg'},
      {'name': 'Product 3', 'image': 'assets/images/product3.jpeg'},
      {'name': 'Product 4', 'image': 'assets/images/product4.jpeg'},
      {'name': 'Product 5', 'image': 'assets/images/product5.jpeg'},
      {'name': 'Product 6', 'image': 'assets/images/product6.jpeg'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Productos de $category'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Número de columnas
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  Routes.productDetail,
                  arguments: product['name'] ?? 'Producto desconocido',
                );
              },
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                        child: Image.asset(
                          product['image']!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        product['name'] ?? 'Producto desconocido',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            Routes.productDetail,
                            arguments: product['name'] ?? 'Producto desconocido',
                          );
                        },
                        child: Text(
                          'Detalles',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text('Selected: $category', textAlign: TextAlign.center),
      ),
    );
  }
}
