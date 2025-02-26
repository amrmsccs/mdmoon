import 'image.dart';

class Product {
  final int id;
  final String name;
  final double price;
  final List<Image> images;
  final String description;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.images,
    required this.description,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    var imageList = json['images'] as List;
    List<Image> images = imageList.map((i) => Image.fromJson(i)).toList();

    return Product(
      id: json['id'],
      name: json['name'],
      price: json['price'].toDouble(),
      images: images,
      description: json['description'],
    );
  }
}