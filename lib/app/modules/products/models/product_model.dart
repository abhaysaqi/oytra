class ProductModel {
  final int id;
  final String title;
  final String description;
  final double price;
  final int moq; // Minimum Order Quantity
  final String category;
  final String thumbnail;

  ProductModel({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.moq,
    required this.category,
    required this.thumbnail,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      price: (json['price'] as num).toDouble(),
      moq: (json['minimumOrderQuantity'] as int?) ?? 5,
      category: json['category'] as String? ?? '',
      thumbnail: json['thumbnail'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'price': price,
        'minimumOrderQuantity': moq,
        'category': category,
        'thumbnail': thumbnail,
      };
}
