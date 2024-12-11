class PurchaseDTO {
  final double totalPurchase;
  final int totalProducts;
  final DateTime date;
  final List<PurchaseItemDTO> items;

  PurchaseDTO({
    required this.totalPurchase,
    required this.totalProducts,
    required this.date,
    required this.items,
  });

  factory PurchaseDTO.fromMap(Map<String, dynamic> map) {
    return PurchaseDTO(
      totalPurchase: map['totalPurchase'] as double,
      totalProducts: map['totalProducts'] as int,
      date: DateTime.parse(map['date'] as String),
      items: (map['items'] as List)
          .map((item) => PurchaseItemDTO.fromMap(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'totalPurchase': totalPurchase,
      'totalProducts': totalProducts,
      'date': date.toIso8601String(),
      'items': items.map((item) => item.toMap()).toList(),
    };
  }
}

class PurchaseItemDTO {
  final String name;
  final int quantity;
  final double total;

  PurchaseItemDTO({
    required this.name,
    required this.quantity,
    required this.total,
  });

  factory PurchaseItemDTO.fromMap(Map<String, dynamic> map) {
    return PurchaseItemDTO(
      name: map['name'] as String,
      quantity: map['quantity'] as int,
      total: map['total'] as double,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'quantity': quantity,
      'total': total,
    };
  }
}
