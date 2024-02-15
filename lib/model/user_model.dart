import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  UserData({required this.id, required this.name, required this.email});

  final String id;
  final String name;
  final String email;

  factory UserData.fromJson(QueryDocumentSnapshot<Map<String, dynamic>> json) {
    return UserData(name: json['name'], email: json['email'], id: json.id);
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'email': email, 'id': id};
  }
}
