import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewedProductsScreen extends StatefulWidget {
  const ViewedProductsScreen({Key? key}) : super(key: key);

  @override
  _ViewedProductsScreenState createState() => _ViewedProductsScreenState();
}

class _ViewedProductsScreenState extends State<ViewedProductsScreen> {
  List<Map<String, String>> visitedProducts = [];

  @override
  void initState() {
    super.initState();
    _loadVisitedProducts();
  }

  Future<void> _loadVisitedProducts() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? visitedProductsList = prefs.getStringList('visitedProducts');

    if (visitedProductsList != null && visitedProductsList.isNotEmpty) {
      List<Map<String, String>> products = [];

      for (var item in visitedProductsList) {
        final splitItem = item.split('|');
        if (splitItem.length == 4) {
          // ID|Name|Price|VisitCount
          final productId = splitItem[0];
          final productName = splitItem[1];
          final productPrice = splitItem[2];
          final visitCount = splitItem[3];

          products.add({
            'id': productId,
            'name': productName,
            'price': productPrice,
            'visitCount': visitCount,
          });
        }
      }

      setState(() {
        visitedProducts = products;
      });
    } else {
      setState(() {
        visitedProducts = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Productos Vistos'),
        backgroundColor: Colors.blue,
      ),
      body: visitedProducts.isEmpty
          ? const Center(child: Text('Aún no has visto productos'))
          : ListView.builder(
              itemCount: visitedProducts.length,
              itemBuilder: (context, index) {
                final product = visitedProducts[index];
                return ListTile(
                  title: Text('Producto: ${product['name']}'),
                  subtitle: Text('ID del producto: ${product['id']}'),
                  trailing: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('Precio: \$${product['price']}'),
                      Text('Visto: ${product['visitCount']} veces'),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
