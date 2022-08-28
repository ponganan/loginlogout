import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loginlogout/home_page.dart';
import 'package:loginlogout/login_page.dart';

import 'auth_page.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Someting went wrong !!'),
            );
          }
          if (snapshot.hasData) {
            return const HomePage();
          } else {
            return AuthPage();
          }
        },
      ),
    );
  }
}
