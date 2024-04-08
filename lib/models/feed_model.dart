class FeedModel {
  final String feedId;
  final String name;
  final int price;
  final int weight;
  final int stock;
  final String image;
  final String description;

  FeedModel({
    required this.feedId,
    required this.name,
    required this.price,
    required this.weight,
    required this.stock,
    required this.description,
    this.image = "",
  });

  factory FeedModel.fromJson(Map<String, dynamic> json) {
    return FeedModel(
      feedId: json['feedId'] ?? "0",
      name: json['name'] ?? "",
      price: json['price'] ?? 0,
      weight: json['weight'] ?? 0,
      stock: json['stock'] ?? 0,
      image: json['image'] ?? "",
      description: json['description'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'feedId': feedId,
      'name': name,
      'price': price,
      'weight': weight,
      'stock': stock,
      'image': image,
      'description': description,
    };
  }
}
