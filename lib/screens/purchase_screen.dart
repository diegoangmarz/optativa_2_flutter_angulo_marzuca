import 'package:flutter/material.dart';


import '../modules/login/domain/dto/purchase_dto.dart';
import '../modules/login/domain/repository/purchase_repository.dart';

class PurchaseScreen extends StatefulWidget {
  final PurchaseRepository purchaseRepository;

  const PurchaseScreen({super.key, required this.purchaseRepository});

  @override
  _PurchaseScreenState createState() => _PurchaseScreenState();
}

class _PurchaseScreenState extends State<PurchaseScreen> {
  late Future<List<PurchaseDTO>> _purchases;

  @override
  void initState() {
    super.initState();
    _purchases = widget.purchaseRepository.getPurchases();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Compras realizadas'),
      ),
      body: FutureBuilder<List<PurchaseDTO>>(
        future: _purchases,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay compras realizadas.'));
          } else {
            final purchases = snapshot.data!;

            return ListView.builder(
              itemCount: purchases.length,
              itemBuilder: (context, index) {
                final purchase = purchases[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ExpansionTile(
                    title: Text('Total: \$${purchase.totalPurchase.toStringAsFixed(2)}'),
                    subtitle: Text(
                      'Productos: ${purchase.totalProducts} | Fecha: ${purchase.date.toLocal()}',
                    ),
                    children: purchase.items.map((item) {
                      return ListTile(
                        title: Text(item.name),
                        subtitle: Text('Cantidad: ${item.quantity} | Total: \$${item.total.toStringAsFixed(2)}'),
                      );
                    }).toList(),
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
