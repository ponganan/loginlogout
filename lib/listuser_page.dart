import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'model/userlist.dart';

class ListUser extends StatefulWidget {
  const ListUser({Key? key}) : super(key: key);

  @override
  State<ListUser> createState() => _ListUserState();
}

class _ListUserState extends State<ListUser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List User'),
      ),

      //in body have to create StreamBuilder for get json data from firestore

      body: StreamBuilder<List<UserList>>(
        stream: readUser(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Something went Wrong! ${snapshot.error}');
          } else if (snapshot.hasData) {
            final user = snapshot.data!;

            return ListView(
              children: user.map(buildUser).toList(),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
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

  Stream<List<UserList>> readUser() => FirebaseFirestore.instance
      .collection('users')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => UserList.fromJson(doc.data())).toList());
}
