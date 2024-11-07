// product_detail_screen.dart
import 'package:flutter/material.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final product = ModalRoute.of(context)?.settings.arguments as String? ?? 'Producto desconocido';

    return Scaffold(
      appBar: AppBar(
        title: Text('Detalle de $product'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Text('Detalles del producto: $product'),
      ),
    );
  }
}
