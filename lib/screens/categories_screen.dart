import 'package:flutter/material.dart';
import '../routes.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final categories = [
      {'name': 'RAAZ', 'date': '2022-12-01 23:57:02.000', 'icon': Icons.shopping_cart},
      {'name': 'INICIO', 'date': '2022-12-01 23:57:02.000', 'icon': Icons.home},
      {'name': 'CARNES AVES HUEVO', 'date': '2023-11-09 09:46:45.000', 'icon': Icons.shopping_cart},
      {'name': 'DALE SABOR A TUS COMIDAS', 'date': '2023-11-09 09:49:47.000', 'icon': Icons.restaurant},
      {'name': 'DEL CAMPO A TU CASA', 'date': '2023-11-09 09:50:51.000', 'icon': Icons.grass},
      {'name': 'DERIVADOS 100% DEL MAÍZ', 'date': '2023-11-09 09:53:05.000', 'icon': Icons.shopping_cart},
      {'name': 'NUESTRAS MIELES', 'date': '2023-11-09 09:55:52.000', 'icon': Icons.bakery_dining},
      {'name': 'PARA PICAR UN RATO', 'date': '2023-11-09 09:59:00.000', 'icon': Icons.fastfood},
      {'name': 'PARA REFRESCARSE', 'date': '2023-11-09 10:00:22.000', 'icon': Icons.local_drink},
      {'name': 'UN DULCE MOMENTO', 'date': '2023-11-09 10:01:10.000', 'icon': Icons.cake},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Categorías'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              // Acción para el icono de configuración
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return ListTile(
            leading: Icon(category['icon'] as IconData?), 
            title: Text(category['name'] as String), 
            subtitle: Text(category['date'] as String), 
            onTap: () {
              Navigator.pushReplacementNamed(context, Routes.products, arguments: category['name']);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacementNamed(context, Routes.products, arguments: 'Categoría seleccionada');
        },
        backgroundColor: Colors.blue,
        child: Icon(Icons.navigate_next),
      ),
    );
  }
}
