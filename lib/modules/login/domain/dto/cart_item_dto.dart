class CartItemDTO {
  final int id;
  final String name;
  final String thumbnail;
  final double price;
  final int quantity;

  CartItemDTO({
    required this.id,
    required this.name,
    required this.thumbnail,
    required this.price,
    required this.quantity,
  });

  // Constructor que mapea un JSON a CartItemDTO
  factory CartItemDTO.fromMap(Map<String, dynamic> map) {
    return CartItemDTO(
      id: map['id'] ?? 0, // Valor predeterminado si es null
      name: map['name'] ?? 'Unknown', // Predeterminado: 'Unknown'
      thumbnail: map['thumbnail'] ?? '', // Predeterminado: cadena vacía
      price: (map['price'] ?? 0).toDouble(), // Asegura que sea un double
      quantity: map['quantity'] ?? 1, // Valor predeterminado: 1
    );
  }

  // Método para convertir CartItemDTO a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'thumbnail': thumbnail,
      'price': price,
      'quantity': quantity,
    };
  }
}
