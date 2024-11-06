import 'package:flutter/material.dart';
import 'routes.dart';
import 'screens/login_screen.dart';
import 'screens/categories_screen.dart';
import 'screens/products_screen.dart';
import 'screens/product_detail_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: Routes.login,
      routes: {
        Routes.login: (context) => LoginScreen(),
        Routes.categories: (context) => CategoriesScreen(),
        Routes.products: (context) => ProductsScreen(),
        Routes.productDetail: (context) => ProductDetailScreen(),
      },
    );
  }
}
