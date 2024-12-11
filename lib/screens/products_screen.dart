// lib/screens/product_screen.dart


import 'package:flutter/material.dart';

import '../infrastructure/connection/api_service.dart';
import '../modules/login/domain/dto/product_dto.dart';
import '../modules/login/domain/repository/product_repository.dart';
import '../modules/login/useCase/fetch_products_by_category_usecase.dart';

class ProductScreen extends StatefulWidget {
  final String category;

  const ProductScreen({super.key, required this.category});

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  late FetchProductsByCategoryUseCase fetchProductsByCategoryUseCase;
  late Future<List<ProductDTO>> products;

  @override
  void initState() {
    super.initState();

    final apiService = ApiService();
    final productRepository = ProductRepositoryImpl(apiService: apiService);
    fetchProductsByCategoryUseCase = FetchProductsByCategoryUseCase(repository: productRepository);

    // Cargar los productos al iniciar la pantalla
    products = fetchProductsByCategoryUseCase.execute(widget.category);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Productos de ${widget.category}'),
      ),
      body: FutureBuilder<List<ProductDTO>>(
        future: products,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay productos'));
          } else {
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
              ),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final product = snapshot.data![index];
                return Card(
                  child: Column(
                    children: [
                      Image.network(
                        product.thumbnail,
                        height: 80,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          product.title,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // Navegar a detalles si tienes esa pantalla
                        },
                        child: const Text('Detalles'),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
