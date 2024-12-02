import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';


class RecentlyViewedScreen extends StatefulWidget {
  const RecentlyViewedScreen({super.key});

  @override
  _RecentlyViewedScreenState createState() => _RecentlyViewedScreenState();
}

class _RecentlyViewedScreenState extends State<RecentlyViewedScreen> {
  List<Map<String, dynamic>> recentlyViewedProducts = [];

  @override
  void initState() {
    super.initState();
    _loadRecentlyViewedProducts();
  }

  Future<void> _loadRecentlyViewedProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final viewedProducts = prefs.getStringList('viewedProducts') ?? [];

    setState(() {
      recentlyViewedProducts = viewedProducts
          .map((e) => Map<String, dynamic>.from(json.decode(e)))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Productos Vistos'),
        backgroundColor: Colors.blue,
      ),
      body: recentlyViewedProducts.isEmpty
          ? const Center(child: Text('No se han visto productos'))
          : ListView.builder(
              itemCount: recentlyViewedProducts.length,
              itemBuilder: (context, index) {
                final product = recentlyViewedProducts[index];
                return ListTile(
                  title: Text(product['name']),
                  subtitle: Text('Visto ${product['viewedCount']} veces'),
                  trailing: Text('\$${product['price']}'),
                );
              },
            ),
    );
  }
}
