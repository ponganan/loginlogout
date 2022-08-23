import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loginlogout/user_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //add this variable to get user information from firebase
  final user = FirebaseAuth.instance.currentUser!;

  //this line add from Johannes Milke Youtube Channel
  //for get Text value
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appbar add from Johannes Milke Youtube Channel
      appBar: AppBar(
        title: TextField(
          //add line for get value from TextEditingController
          controller: controller,
        ),
        //add button to add value to firestore
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              //give name equal Text value
              final name = controller.text;

              createUser(name: name);
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Add ElevatedButton to push Button to Add user
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return const UserPage();
                    },
                  ),
                );
              },
              child: const Text('Add User'),
            ),
            const SizedBox(height: 28),
            Text(
              'Signed In as : ' + user.email!,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 15),
            MaterialButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              color: Colors.green[200],
              child: const Text('Sign Out'),
            ),
          ],
        ),
      ),
    );
  }

  // Create function to pass value to firestore
  Future createUser({required String name}) async {
    final docUser = FirebaseFirestore.instance.collection('users').doc();
    final user = User2(
      id: docUser.id,
      name: name,
      age: 21,
      birthday: DateTime.now(),
    );
    final json = user.toJson();
    //create document and write data to firebase
    await docUser.set(json);
  }
}

//************************************************//
// New Flutter have to create Class and define object//
//************************************************//

class User2 {
  String id;
  final String name;
  final int age;
  final DateTime birthday;
  User2({
    this.id = '',
    required this.name,
    required this.age,
    required this.birthday,
  });

  //************************************************//
  // HAVE TO USE THIS CODE TO MAP JSON TO FIREBASE //
  //************************************************//

  Map<String, dynamic> toJson() =>
      {'id': id, 'name': name, 'age': age, 'birthday': birthday};
}
