import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loginlogout/providers/auth_view_model.dart';

class Profile extends ConsumerWidget {
  Profile({Key? key}) : super(key: key);

  //************ for get AUTH USER information *****************
  final user = FirebaseAuth.instance.currentUser!;

  //************ for get AUTH USER information *****************
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final model = ref.read(authViewModelProvider);
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
            const SizedBox(height: 10),
            Text(
              'Data From Firebase',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'Logged In as : ' + user.email!,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 28),
            Text(
              ' UID : ' + user.uid,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 60),
            Text(
              'Data From Riverpod',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'Username : ' + model.email,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 28),
            Text(
              ' Password : ' + model.password,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 45),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
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
