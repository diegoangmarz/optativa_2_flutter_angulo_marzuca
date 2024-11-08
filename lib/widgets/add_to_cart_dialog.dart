import 'package:flutter/material.dart';
import '../models/cart_model.dart';  // Asegúrate de que esta importación es correcta y el archivo existe

class AddToCartDialog extends StatelessWidget {
  final List<Cart> carts;

  const AddToCartDialog({super.key, required this.carts});  // Usar super.key para el constructor

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Seleccionar Carrito'),
      content: SizedBox(
        width: double.maxFinite,
        height: 400,
        child: ListView.builder(
          itemCount: carts.length,
          itemBuilder: (context, index) {
            final cart = carts[index];
            return ListTile(
              title: Text('Carrito ID: ${cart.id}'),
              subtitle: Text('Total: \$${cart.total}'),
              onTap: () {
                Navigator.of(context).pop(cart.id);
              },
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
      ],
    );
  }
}
