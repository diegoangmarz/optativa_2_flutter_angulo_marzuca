import 'package:flutter/material.dart';
import 'screens/product_detail_screen.dart';
import 'screens/products_screen.dart';
import 'screens/login_screen.dart';
import 'screens/categories_screen.dart';
import 'routes.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: Routes.login,
      routes: {
        Routes.login: (context) =>  LoginScreen(),
        Routes.categories: (context) => const CategoriesScreen(),
        Routes.products: (context) => const ProductsScreen(),
        Routes.productDetail: (context) => const ProductDetailScreen(),
      },
    );
  }
}
