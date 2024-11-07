import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../routes.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  CategoriesScreenState createState() => CategoriesScreenState();
}

class CategoriesScreenState extends State<CategoriesScreen> {
  List<Map<String, dynamic>> categories = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      final response = await http.get(Uri.parse('https://dummyjson.com/products/categories'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('API Response: $data');  
        if (data is List) {
          setState(() {
            categories = List<Map<String, dynamic>>.from(data);
            isLoading = false;
          });
        } else {
          throw Exception('Unexpected data format');
        }
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (error) {
      setState(() {
        errorMessage = 'Error fetching categories: $error';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categorías'),
        backgroundColor: Colors.blue,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : ListView.builder(
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    return ListTile(
                      leading: Icon(Icons.category),
                      title: Text(category['name']),  
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          Routes.products,
                          arguments: category['slug'],  
                        );
                      },
                    );
                  },
                ),
    );
  }
}
