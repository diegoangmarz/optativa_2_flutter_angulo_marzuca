import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../dto/cart_item_dto.dart';


class CartRepository {
  final String _cartKey = 'cart';

  Future<List<CartItemDTO>> getCartItems() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final cartData = prefs.getString(_cartKey); // Cambiado a getString

    // Verifica si `cartData` es nulo o vacío
    if (cartData == null || cartData.isEmpty) {
      return [];
    }

    // Decodifica el JSON string a una lista de mapas
    final List<dynamic> decodedData = jsonDecode(cartData);

    // Mapea la lista decodificada a objetos CartItemDTO
    return decodedData.map((item) {
      return CartItemDTO.fromMap(item as Map<String, dynamic>);
    }).toList();
  } catch (e) {
    print('Error getting cart items: $e');
    return [];
  }
}


  Future<void> addCartItem(CartItemDTO item) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    List<CartItemDTO> cartItems = await getCartItems();

    // Busca si el artículo ya está en el carrito
    final index = cartItems.indexWhere((cartItem) => cartItem.id == item.id);
    if (index != -1) {
      // Si el artículo ya existe, actualiza la cantidad
      cartItems[index] = CartItemDTO(
        id: item.id,
        name: item.name,
        thumbnail: item.thumbnail,
        price: item.price,
        quantity: cartItems[index].quantity + item.quantity,
      );
    } else if (cartItems.length < 7) {
      // Si el artículo no existe y hay espacio, agrégalo al carrito
      cartItems.add(item);
    }

    // Guarda el carrito actualizado como un único JSON string
    await prefs.setString(
        _cartKey, json.encode(cartItems.map((item) => item.toMap()).toList()));
  } catch (e) {
    print('Error adding item to cart: $e');
  }
}



  Future<void> removeCartItem(int id) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    List<CartItemDTO> cartItems = await getCartItems();

    // Elimina el artículo con el ID especificado
    cartItems.removeWhere((item) => item.id == id);

    // Guarda el carrito actualizado como un único JSON string
    await prefs.setString(
        _cartKey, json.encode(cartItems.map((item) => item.toMap()).toList()));
  } catch (e) {
    print('Error removing item from cart: $e');
  }
}


  Future<void> clearCart() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cartKey);  // Elimina el carrito de SharedPreferences
  } catch (e) {
    print('Error clearing cart: $e');
  }
}

}

