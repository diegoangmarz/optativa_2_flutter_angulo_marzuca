
import 'package:flutter/material.dart'; // Asegúrate de importar la pantalla de detalles

import '../infrastructure/connection/api_service.dart';
import '../modules/login/domain/dto/product_dto.dart';
import '../modules/login/domain/repository/product_repository.dart';
import '../screens/product_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  late ProductRepository productRepository;
  late List<ProductDTO> _products = [];

  @override
  void initState() {
    super.initState();
    productRepository = ProductRepositoryImpl(apiService: ApiService());
  }

  void _searchProducts(String query) async {
    try {
      print('Buscando productos con el término: $query');
      final products = await productRepository.searchProducts(query);
      setState(() {
        _products = products;
      });
    } catch (error) {
      print('Error fetching products: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar Productos'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Buscar',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.search),
              ),
              onSubmitted: _searchProducts,
            ),
          ),
          Expanded(
            child: _products.isEmpty
                ? const Center(child: Text('No se encontraron productos'))
                : ListView.builder(
                    itemCount: _products.length,
                    itemBuilder: (context, index) {
                      final product = _products[index];
                      return ListTile(
                        title: Text(product.title),
                        onTap: () {
                          // Navegar a la pantalla de detalles del producto
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetailScreen(
                                productId: product.id,  // Usamos product.id directamente como String
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
