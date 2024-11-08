import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CartDetailsScreen extends StatefulWidget {
  const CartDetailsScreen({Key? key}) : super(key: key);

  @override
  _CartDetailsScreenState createState() => _CartDetailsScreenState();
}

class _CartDetailsScreenState extends State<CartDetailsScreen> {
  Map<String, dynamic>? cart;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchCartDetails();
    });
  }

  Future<void> fetchCartDetails() async {
    final cartId = ModalRoute.of(context)?.settings.arguments as String?;
    if (cartId != null) {
      final response = await http.get(Uri.parse('https://dummyjson.com/carts/$cartId'));
      if (response.statusCode == 200) {
        setState(() {
          cart = json.decode(response.body);
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load cart details');
      }
    } else {
      setState(() {
        isLoading = false;
        print('Cart ID is null');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles del Carrito'),
        backgroundColor: Colors.blue,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : cart == null
              ? Center(child: Text('No se encontraron detalles del carrito.'))
              : ListView.builder(
                  itemCount: cart!['products'].length,
                  itemBuilder: (context, index) {
                    final product = cart!['products'][index];
                    return ListTile(
                      leading: Image.network(
                        product['thumbnail'],
                        fit: BoxFit.cover,
                        width: 50,
                        height: 50,
                      ),
                      title: Text(product['title']),
                      subtitle: Text('Cantidad: ${product['quantity']} - Total: \$${product['total']}'),
                    );
                  },
                ),
    );
  }
}
