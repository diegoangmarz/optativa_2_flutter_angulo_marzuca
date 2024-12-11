class ProductDetailDTO {
  final int id;
  final String title;
  final String description;
  final double price;
  final int stock;
  final List<String> images;
  final List<Map<String, dynamic>> reviews;

  ProductDetailDTO({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.stock,
    required this.images,
    required this.reviews,
  });

  factory ProductDetailDTO.fromJson(Map<String, dynamic> json) {
    return ProductDetailDTO(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'Sin título',
      description: json['description'] ?? 'Sin descripción',
      price: (json['price'] ?? 0).toDouble(),
      stock: json['stock'] ?? 0,
      images: List<String>.from(json['images'] ?? []),
      reviews: List<Map<String, dynamic>>.from(json['reviews'] ?? []).map((review) {
        return {
          'rating': review['rating'] ?? 0,
          'comment': review['comment'] ?? 'Sin comentario',
          'reviewerName': review['reviewerName'] ?? 'Usuario desconocido',
          'reviewerEmail': review['reviewerEmail'] ?? '',
          'date': review['date'] ?? '',
        };
      }).toList(),
    );
  }
}
