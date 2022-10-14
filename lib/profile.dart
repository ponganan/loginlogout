import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loginlogout/home_page.dart';
import 'package:loginlogout/listuser_page.dart';
import 'package:loginlogout/user_page.dart';
import 'package:loginlogout/userdetail_page.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  //************ for get AUTH USER information *****************
  //add this variable to get user information from firebase
  final user = FirebaseAuth.instance.currentUser!;

  //************ for get AUTH USER information *****************

  //this line add from Johannes Milke Youtube Channel
  //for get Text value

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appbar add from Johannes Milke Youtube Channel
      appBar: AppBar(
        // title: TextField(
        //   //add line for get value from TextEditingController
        //   controller: controller,
        // ),
        // //add button to add value to firestore
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.add),
        //     onPressed: () {
        //       //give name equal Text value
        //       final name = controller.text;
        //
        //       createUser(name: name);
        //     },
        //   ),
        // ],
        centerTitle: true,
        title: const Text('Profile'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 28),
            Text(
              'Logged In as : ' + user.email!,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 28),
            Text(
              ' UID : ' + user.uid,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return const HomePage();
                    },
                  ),
                );
              },
              child: const Text(
                'Back to HomePage',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(height: 28),
          ],
        ),
      ),
    );
  }
}

// Create function to pass value to firestore

//************************************************//
// New Flutter have to create Class and define object//
//************************************************//
