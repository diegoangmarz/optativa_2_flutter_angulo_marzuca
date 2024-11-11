import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../routes.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  List<Map<String, dynamic>> products = [];
  bool isLoading = true;
  String category = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final categoryArg = ModalRoute.of(context)?.settings.arguments as String?;
    if (categoryArg != null && categoryArg != category) {
      category = categoryArg;
      fetchProducts(category);
    }
  }

  Future<void> fetchProducts(String category) async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await http.get(Uri.parse('https://dummyjson.com/products/category/$category'));
      print('Fetching products from URL: https://dummyjson.com/products/category/$category');  
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('API Response: $data'); 
        if (data['products'] is List) {
          setState(() {
            products = List<Map<String, dynamic>>.from(data['products']);
            isLoading = false;
          });
        } else {
          throw Exception('Unexpected data format');
        }
      } else {
        print('Failed to load products. Status code: ${response.statusCode}'); 
        throw Exception('Failed to load products');
      }
    } catch (error) {
      setState(() {
        isLoading = false;
        print('Error fetching products: $error');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayCategory = category;

    return Scaffold(
      appBar: AppBar(
        title: Text(displayCategory),
        backgroundColor: Colors.blue,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      Routes.productDetail,
                      arguments: product['id'].toString(),
                    );
                  },
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                product['thumbnail'] ?? '',
                                fit: BoxFit.cover,
                                height: 100,
                                width: 100,
                                errorBuilder: (context, error, stackTrace) {
                                  return Center(child: Icon(Icons.image, color: Colors.grey, size: 50));
                                },
                              ),
                            ),
                          ),
                          SizedBox(width: 16.0),
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product['title'] ?? 'Producto desconocido',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 8.0),
                                Text(
                                  '\$${product['price']}',
                                  style: TextStyle(fontSize: 16, color: Colors.green),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
