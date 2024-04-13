import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel {
  const CategoryModel(
      {required this.id, required this.name, required this.imageUrl});

  final String id;
  final String name;

  final String imageUrl;

  factory CategoryModel.fromJson(QueryDocumentSnapshot json) {
    return CategoryModel(
      id: json.id,
      name: json['name'],
      imageUrl: json['imageUrl'],
    );
  }
}
