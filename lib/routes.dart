import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/HomeScreen.dart';

class Routes {
  static const String login = '/login';
  static const String categories = '/categories';
  static const String home = '/home';

static Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case login:
      return MaterialPageRoute(builder: (_) => LoginScreen());
    case home:
      return MaterialPageRoute(builder: (_) => const HomeScreen());
    // Otros casos
    default:
      return MaterialPageRoute(
        builder: (_) => const Scaffold(
          body: Center(child: Text('Ruta no definida')),
        ),
      );
  }
}

}