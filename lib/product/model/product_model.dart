import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  const ProductModel(
      {required this.imageUrl,
      required this.id,
      required this.wishlist,
      required this.productName,
      required this.categoryName,
      required this.description});

  final String id;
  final String productName;
  final String description;
  final String imageUrl;
  final bool wishlist;
  final String categoryName;

  factory ProductModel.fromJson(QueryDocumentSnapshot json) {
    return ProductModel(
        id: json.id,
        categoryName: json['categoryName'],
        productName: json['name'],
        description: json['description'],
        imageUrl: json['imageUrl'],
        wishlist: json['wishlist']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'categoryName': categoryName,
      'name': productName,
      'description': description,
      'imageUrl': imageUrl,
      'wishlist': wishlist,
    };
  }
}
