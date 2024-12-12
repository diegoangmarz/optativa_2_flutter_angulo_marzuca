import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/homescreen.dart';
import 'screens/categories_screen.dart';
import 'screens/products_screen.dart'; 
import 'screens/product_detail_screen.dart';  // Importa ProductDetailScreen

class Routes {
  static const String login = '/login';
  static const String categories = '/categories';
  static const String home = '/home';
  static const String products = '/products';
  static const String productDetail = '/productDetail';  // Define la ruta para ProductDetailScreen

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case home:
        return MaterialPageRoute(builder: (_) => HomeScreen()); 
      case categories:
        return MaterialPageRoute(builder: (_) => CategoriesScreen());
      case products:
        final args = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => ProductsScreen(category: args),
        );
      case productDetail:
        final args = settings.arguments as int;  // Recibe el ID del producto como argumento
        return MaterialPageRoute(
          builder: (_) => ProductDetailScreen(productId: args),  // Pasa el argumento a ProductDetailScreen
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Ruta no definida')),
          ),
        );
    }
  }
}
