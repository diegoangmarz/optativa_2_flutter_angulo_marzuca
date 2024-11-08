import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../routes.dart';

class CartsScreen extends StatefulWidget {
  const CartsScreen({Key? key}) : super(key: key);

  @override
  _CartsScreenState createState() => _CartsScreenState();
}

class _CartsScreenState extends State<CartsScreen> {
  List<Map<String, dynamic>> carts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCarts();
  }

  Future<void> fetchCarts() async {
    final response = await http.get(Uri.parse('https://dummyjson.com/carts'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        carts = List<Map<String, dynamic>>.from(data['carts']);
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load carts');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Listas de Compras'),
        backgroundColor: Colors.blue,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: carts.length,
              itemBuilder: (context, index) {
                final cart = carts[index];
                return ListTile(
                  title: Text('Carrito ID: ${cart['id']}'),
                  subtitle: Text('Total: \$${cart['total']}'),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      Routes.cartDetails,
                      arguments: cart['id'].toString(),
                    );
                  },
                );
              },
            ),
    );
  }
}
