
class Cart {
  final int id;
  final int userId;
  final double total;
  final double discountedTotal;
  final int totalProducts;
  final int totalQuantity;
  final List<dynamic> products;

  Cart({
    required this.id,
    required this.userId,
    required this.total,
    required this.discountedTotal,
    required this.totalProducts,
    required this.totalQuantity,
    required this.products,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      id: json['id'],
      userId: json['userId'],
      total: json['total'],
      discountedTotal: json['discountedTotal'],
      totalProducts: json['totalProducts'],
      totalQuantity: json['totalQuantity'],
      products: json['products'],
    );
  }
}
