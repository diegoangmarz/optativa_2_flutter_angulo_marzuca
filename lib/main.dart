import 'package:flutter/material.dart';
import 'package:optativa_2_flutter_angulo_marzuca/screens/product_detail_screen.dart';
import 'package:optativa_2_flutter_angulo_marzuca/screens/products_screen.dart';
import 'screens/login_screen.dart';
import 'screens/categories_screen.dart';
import 'routes.dart';

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
        Routes.productDetail: (context ) => ProductDetailScreen() ,
        Routes.products: (context) => ProductsScreen()     },
    );
  }
}
