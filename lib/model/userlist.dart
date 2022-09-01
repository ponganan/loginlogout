import 'package:cloud_firestore/cloud_firestore.dart';

class UserList {
  String id;
  final String name;
  final int age;
  final DateTime birthday;

  UserList({
    this.id = '',
    required this.name,
    required this.age,
    required this.birthday,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'age': age,
        'birthday': birthday,
      };

  static UserList fromJson(Map<String, dynamic> json) => UserList(
      id: json['id'],
      name: json['name'],
      age: json['age'],
      birthday: (json['birthday'] as Timestamp).toDate());
}
