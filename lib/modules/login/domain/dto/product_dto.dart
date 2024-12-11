class ProductDTO {
  final int id;
  final String title;
  final String thumbnail;

  ProductDTO({required this.id, required this.title, required this.thumbnail});

  factory ProductDTO.fromJson(Map<String, dynamic> json) {
    return ProductDTO(
      id: json['id'],
      title: json['title'],
      thumbnail: json['thumbnail'],
    );
  }
}
