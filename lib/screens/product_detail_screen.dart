
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'cart_screen.dart';

import '../modules/login/domain/repository/cart_repository.dart';
import '../modules/login/domain/repository/product_detail_repository.dart';
import '../modules/login/useCase/get_cart_items_usecase.dart';
import '../modules/login/useCase/remove_from_cart_usecase.dart';
import '../infrastructure/connection/api_service.dart';
import '../modules/login/domain/dto/product_detail_dto.dart';
import '../modules/login/useCase/fetch_product_detail_usecase.dart';

class ProductDetailScreen extends StatefulWidget {
  final int productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late FetchProductDetailUseCase fetchProductDetailUseCase;
  late GetCartItemsUseCase getCartItemsUseCase; // Asegúrate de definir esta variable
  late Future<ProductDetailDTO> productDetail;
  final TextEditingController _quantityController = TextEditingController();
  late List<dynamic> cartItems;

  @override
  void initState() {
    super.initState();
    final apiService = ApiService();
    final productDetailRepository = ProductDetailRepositoryImpl(apiService: apiService);
    fetchProductDetailUseCase = FetchProductDetailUseCase(repository: productDetailRepository);
    productDetail = fetchProductDetailUseCase.execute(widget.productId);
    _loadCartItems();
  }

  Future<void> _loadCartItems() async {
    final prefs = await SharedPreferences.getInstance();
    final cartData = prefs.getString('cart') ?? '[]';
    cartItems = jsonDecode(cartData);
  }

  Future<void> _addToViewedProducts(ProductDetailDTO product) async {
    final prefs = await SharedPreferences.getInstance();
    final viewedData = prefs.getString('viewed_products') ?? '[]';
    final List<dynamic> viewedProducts = jsonDecode(viewedData);

    final existingProductIndex = viewedProducts.indexWhere((item) => item['productId'] == product.id);
    if (existingProductIndex != -1) {
      viewedProducts[existingProductIndex]['viewCount'] += 1;
    } else {
      viewedProducts.add({
        'productId': product.id,
        'name': product.title,
        'price': product.price,
        'viewCount': 1,
      });
    }

    await prefs.setString('viewed_products', jsonEncode(viewedProducts));
  }

  bool _shouldHideAddToCartButton(ProductDetailDTO product) {
    final cartItem = cartItems.firstWhere(
      (item) => item['productId'] == product.id,
      orElse: () => null,
    );

    final productStock = product.stock;
    final productQuantityInCart = cartItem != null ? cartItem['quantity'] as int : 0;

    return productStock <= 0 || productQuantityInCart >= productStock;
  }

  Future<void> _addToCart(ProductDetailDTO product) async {
    final quantity = int.tryParse(_quantityController.text) ?? 0;

    if (quantity <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cantidad debe ser mayor a cero')),
      );
      return;
    }

    if (quantity > product.stock) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No hay suficiente stock')),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final cartData = prefs.getString('cart') ?? '[]';
    final List<dynamic> cart = jsonDecode(cartData);

    final existingProductIndex = cart.indexWhere((item) => item['productId'] == product.id);
    if (existingProductIndex != -1) {
      cart[existingProductIndex]['quantity'] += quantity;

      if (cart[existingProductIndex]['quantity'] > product.stock) {
        cart[existingProductIndex]['quantity'] = product.stock;
      }

      cart[existingProductIndex]['total'] = cart[existingProductIndex]['quantity'] * product.price;
    } else {
      if (cart.length >= 7) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No puedes agregar más de 7 productos diferentes')),
        );
        return;
      }
      cart.add({
        'productId': product.id,
        'name': product.title,
        'quantity': quantity,
        'price': product.price,
        'total': quantity * product.price,
      });
    }

    await prefs.setString('cart', jsonEncode(cart));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Producto añadido al carrito')),
    );

    _loadCartItems();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles del Producto'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              final cartRepository = CartRepository();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartScreen(
                    getCartItemsUseCase: GetCartItemsUseCase(cartRepository),
                    removeFromCartUseCase: RemoveFromCartUseCase(cartRepository),
                    cartRepository: cartRepository,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<ProductDetailDTO>(
        future: productDetail,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Detalles del producto no encontrados'));
          } else {
            final product = snapshot.data!;
            _addToViewedProducts(product);  // Agregar el producto a productos vistos
            final shouldHideButton = _shouldHideAddToCartButton(product);

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.network(
                    product.images.isNotEmpty ? product.images[0] : 'default_image_url',
                    height: 250,
                    fit: BoxFit.cover,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      product.title,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      product.description,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      '\$${product.price}',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
                    ),
                  ),
                  if (shouldHideButton)
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'Producto agotado',
                        style: TextStyle(fontSize: 18, color: Colors.red, fontWeight: FontWeight.bold),
                      ),
                    )
                  else ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextField(
                        controller: _quantityController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Cantidad',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: ElevatedButton(
                        onPressed: () => _addToCart(product),
                        child: const Text('Agregar al carrito'),
                      ),
                    ),
                  ],
                  // Reseñas
                  Padding(
  padding: const EdgeInsets.all(16.0),
  child: Text(
    'Reseñas:',
    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
  ),
),
// Si no hay reseñas
if (product.reviews.isEmpty)
  const Padding(
    padding: EdgeInsets.symmetric(horizontal: 16.0),
    child: Text('No hay reseñas para este producto.'),
  )
// Mostrar las reseñas
else
  ...product.reviews.map((review) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${review['comment']}',
            style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
          ),
          const SizedBox(height: 4),
          Text(
            '- ${review['reviewerName']} (${review['rating']} estrellas)',
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            'Fecha: ${review['date']}',
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }).toList(),

                ],
              ),
            );
          }
        },
      ),
    );
  }
}