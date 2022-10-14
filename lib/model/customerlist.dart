import 'package:cloud_firestore/cloud_firestore.dart';

class CustomerList {
  String id;
  final String name;
  final int age;

  CustomerList({
    this.id = '',
    required this.name,
    required this.age,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'age': age,
      };

  static CustomerList fromJson(Map<String, dynamic> json) => CustomerList(
        id: json['id'],
        name: json['name'],
        age: json['age'],
      );
}
