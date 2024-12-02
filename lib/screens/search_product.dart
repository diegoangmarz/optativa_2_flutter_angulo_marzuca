import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class SearchView extends StatefulWidget {
  const SearchView({Key? key}) : super(key: key);

  @override
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  List<Map<String, dynamic>> products = [];
  bool isLoading = false;
  TextEditingController searchController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController categoryController = TextEditingController();

  Future<void> searchProducts(String query) async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(Uri.parse('https://dummyjson.com/products/search?q=$query'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['products'] is List) {
          setState(() {
            products = List<Map<String, dynamic>>.from(data['products']);
            isLoading = false;
          });
        } else {
          throw Exception('Unexpected data format');
        }
      } else {
        throw Exception('Failed to load products');
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      print('Error searching products: $error');
    }
  }

  void handleSearch() {
    String query = searchController.text;
    String title = titleController.text;
    String category = categoryController.text;

    String searchQuery = query;
    if (title.isNotEmpty) {
      searchQuery += ' title:$title';
    }
    if (category.isNotEmpty) {
      searchQuery += ' category:$category';
    }

    if (searchQuery.isNotEmpty) {
      searchProducts(searchQuery);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Products'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search for a product',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            const SizedBox(height: 8.0),
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                hintText: 'Title',
                prefixIcon: Icon(Icons.title),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            const SizedBox(height: 8.0),
            TextField(
              controller: categoryController,
              decoration: InputDecoration(
                hintText: 'Category',
                prefixIcon: Icon(Icons.category),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: handleSearch,
              child: Text('Search'),
            ),
            const SizedBox(height: 16.0),
            isLoading
                ? Center(child: CircularProgressIndicator())
                : Expanded(
                    child: products.isEmpty
                        ? Center(child: Text('No products found.'))
                        : ListView.builder(
                            itemCount: products.length,
                            itemBuilder: (context, index) {
                              final product = products[index];
                              return Card(
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
                                              return Center(
                                                child: Icon(Icons.image, color: Colors.grey, size: 50),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 16.0),
                                      Expanded(
                                        flex: 2,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              product['title'] ?? 'Unknown Product',
                                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(height: 8.0),
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
                              );
                            },
                          ),
                  ),
          ],
        ),
      ),
    );
  }
}
