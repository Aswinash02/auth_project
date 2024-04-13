import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  const ProductModel(
      {required this.imageUrl,
      required this.id,
      required this.wishlist,
      required this.productName,
      required this.price,
      this.unit,
      required this.categoryName,
      required this.description});

  final String id;
  final String? unit;
  final String productName;
  final String description;
  final String imageUrl;
  final bool wishlist;
  final double price;
  final String categoryName;

  factory ProductModel.fromJson(QueryDocumentSnapshot json) {
    return ProductModel(
        id: json.id,
        categoryName: json['categoryName'],
        productName: json['name'],
        description: json['description'],
        unit: json['unit'],
        imageUrl: json['imageUrl'],
        wishlist: json['wishlist'],
        price: json['price']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'categoryName': categoryName,
      'name': productName,
      'description': description,
      'imageUrl': imageUrl,
      'wishlist': wishlist,
      'price': price,
      'unit': unit
    };
  }
}
