import 'package:flutter/material.dart';
import 'screens/carts_screen.dart';
import 'screens/product_detail_screen.dart';
import 'screens/products_screen.dart';
import 'screens/login_screen.dart';
import 'screens/categories_screen.dart';
import 'screens/cart_details_screen.dart';
import 'screens/purchases_screen.dart'; 
import 'screens/search_product.dart';  
import 'screens/viewed_product_screen.dart';
import 'routes.dart';

void main() => runApp(const MyApp());

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
        Routes.login: (context) => const LoginScreen(),
        Routes.categories: (context) => const CategoriesScreen(),
        Routes.products: (context) => const ProductsScreen(),
        Routes.productDetail: (context) => const ProductDetailScreen(),
        Routes.carts: (context) => const CartsScreen(),
        Routes.cartDetails: (context) => const CartDetailsScreen(),
        Routes.purchases: (context) => const PurchasesScreen(), 
        Routes.search: (context) => const SearchView(), 
        Routes.ViewedProductsScreen: (context) => const RecentlyViewedScreen(),

      },
    );
  }
}
