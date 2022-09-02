import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'model/userlist.dart';

class UserDetailPage extends StatefulWidget {
  const UserDetailPage({Key? key}) : super(key: key);

  @override
  State<UserDetailPage> createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {
  //add this variable to get user information from firebase
  final user = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List User'),
      ),

      //in body have to create StreamBuilder for get json data from firestore

      body: FutureBuilder<UserList?>(
        future: readUser(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Something went Wrong! ${snapshot.error}');
          } else if (snapshot.hasData) {
            final user = snapshot.data;
            return user == null
                ? const Center(child: Text('No User'))
                : buildUser(user);
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Widget buildUser(UserList user) => ListTile(
        leading: CircleAvatar(child: Text('${user.age}')),
        title: Text(user.name),
        subtitle: Text(user.birthday.toIso8601String()),
      );

  // List All Users Data
  Stream<List<UserList>> readUsers() => FirebaseFirestore.instance
      .collection('users')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => UserList.fromJson(doc.data())).toList());

  //List User Login data with Firebase Auth ID
  Future<UserList?> readUser() async {
    // get single document by ID
    final docUser =
        FirebaseFirestore.instance.collection('users').doc(user.uid);
    final snapshot = await docUser.get();

    if (snapshot.exists) {
      return UserList.fromJson(snapshot.data()!);
    }
    return null;
  }
}
