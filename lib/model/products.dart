class Product {
  final int id;
  final int price;
  final String title;
  final String image;
  final String description;

  const Product({
    required this.price,
    required this.id,
    required this.title,
    required this.image,
    required this.description,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      price: json['price'],
      id: json['id'],
      title: json['title'],
      image: json['image'],
      description: json['description'],
    );
  }
}