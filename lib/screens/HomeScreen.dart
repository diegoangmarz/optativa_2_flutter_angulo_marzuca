
import 'package:flutter/material.dart';

import '../modules/login/domain/repository/cart_repository.dart';
import '../modules/login/useCase/get_cart_items_usecase.dart';
import '../modules/login/useCase/remove_from_cart_usecase.dart';
import '../screens/cart_screen.dart';
import '../screens/search_screen.dart';
import '../screens/user_profile_screen.dart';
import '../screens/viewed_products_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  late List<Widget> _screens;
   late GetCartItemsUseCase getCartItemsUseCase;
  late RemoveFromCartUseCase removeFromCartUseCase;
  late CartRepository cartRepository;
  
  

  @override
  void initState() {
    super.initState();

    cartRepository = CartRepository(); // o CartRepositoryImpl si tienes implementación específica
    getCartItemsUseCase = GetCartItemsUseCase(cartRepository);  // Inicialización del caso de uso
    removeFromCartUseCase = RemoveFromCartUseCase(cartRepository);
    _screens = [
      SearchScreen(),
      CartScreen(
        getCartItemsUseCase: getCartItemsUseCase,
        removeFromCartUseCase: removeFromCartUseCase,
        cartRepository: cartRepository,  // Pasar el repositorio al CartScreen
      ),
      ViewedProductsScreen(),
      UserProfileScreen(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],  // La pantalla se cambiará en base al índice
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.blue,  // Cambia el fondo del BottomNavigationBar
        selectedItemColor: Colors.white,  // Cambia el color del ítem seleccionado
        unselectedItemColor: Colors.grey,  // Cambia el color de los ítems no seleccionados
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Buscar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Carrito',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.visibility),
            label: 'Vistos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
