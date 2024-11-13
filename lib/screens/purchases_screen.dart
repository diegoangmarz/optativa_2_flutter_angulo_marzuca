import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class PurchasesScreen extends StatefulWidget {
  const PurchasesScreen({Key? key}) : super(key: key);

  @override
  _PurchasesScreenState createState() => _PurchasesScreenState();
}

class _PurchasesScreenState extends State<PurchasesScreen> {
  List<Map<String, dynamic>> purchases = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPurchases();
  }

  Future<void> fetchPurchases() async {
    final prefs = await SharedPreferences.getInstance();
    final String? purchasesData = prefs.getString('finalized_cart');
    if (purchasesData != null) {
      setState(() {
        final data = json.decode(purchasesData);
        purchases = [data].cast<Map<String, dynamic>>();
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Compras realizadas'),
        backgroundColor: Colors.blue,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : purchases.isEmpty
              ? const Center(child: Text('No hay compras realizadas'))
              : ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: purchases.length,
                  itemBuilder: (context, index) {
                    final purchase = purchases[index];
                    return Card(
                      elevation: 5,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Total de compra: \$${purchase['total']}'),
                            Text('Total de productos: ${purchase['quantity']}'),
                            Text('Fecha de la compra: ${purchase['date']}'),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
