import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CreateCartDialog extends StatefulWidget {
  const CreateCartDialog({Key? key}) : super(key: key);

  @override
  _CreateCartDialogState createState() => _CreateCartDialogState();
}

class _CreateCartDialogState extends State<CreateCartDialog> {
  final TextEditingController _userIdController = TextEditingController();
  bool isLoading = false;

  void _createCart() async {
    final userId = int.tryParse(_userIdController.text);
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, ingrese un ID de usuario válido.')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    final response = await http.post(
      Uri.parse('https://dummyjson.com/carts/add'),
      headers: { 'Content-Type': 'application/json' },
      body: json.encode({
        'userId': userId,
        'products': [], 
      }),
    );

    setState(() {
      isLoading = false;
    });

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      Navigator.of(context).pop(data);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Carrito creado con éxito.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al crear el carrito.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Crear Carrito'),
      content: isLoading
          ? const Center(child: CircularProgressIndicator())
          : TextField(
              controller: _userIdController,
              decoration: const InputDecoration(
                labelText: 'ID de Usuario',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _createCart,
          child: const Text('Crear'),
        ),
      ],
    );
  }
}
