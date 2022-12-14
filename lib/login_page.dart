import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loginlogout/providers/auth_view_model.dart';
import 'package:loginlogout/utils.dart';

import 'forgot_password_page.dart';
import 'main.dart';

class LoginPage extends ConsumerStatefulWidget {
  final VoidCallback onClickedSignUp;

  const LoginPage({
    Key? key,
    required this.onClickedSignUp,
  }) : super(key: key);

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  //release memories
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final model = ref.watch(authViewModelProvider);
    return Scaffold(
      backgroundColor: Colors.green[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // const Icon(
                //   Icons.fastfood,
                //   size: 150,
                // ),
                const SizedBox(height: 30),
                //Hello
                Text(
                  'Login',
                  style: GoogleFonts.bebasNeue(fontSize: 56),
                ),
                const SizedBox(height: 10),
                const Text(
                  // 'Welcome back, you\'ve been missed!!',
                  'Username : mukdahanonline@gmail.com',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  // 'Welcome back, you\'ve been missed!!',
                  'Password : 123456',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 50),
                //email
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      border: Border.all(
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: TextField(
                        controller: _emailController,
                        //change riverpod state
                        onChanged: (v) => model.email = v,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.email_outlined),
                          border: InputBorder.none,
                          hintText: ('Email'),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                //password
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      border: Border.all(
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: TextField(
                        controller: _passwordController,
                        //obscureText for don't show password text
                        obscureText: true,
                        //change riverpod state
                        onChanged: (v) => model.password = v,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.key_outlined),
                          border: InputBorder.none,
                          hintText: ('Password'),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                //sign in
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: GestureDetector(
                    onTap: signIn,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.deepPurpleAccent,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.lock_open,
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Login',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ]),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                //forgot password
                GestureDetector(
                  child: RichText(
                    text: TextSpan(
                      text: ('Forgot Password'),
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Theme.of(context).colorScheme.secondary),
                    ),
                  ),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ForgotPasswordPage(),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                //register
                RichText(
                  text: TextSpan(
                      text: ('No Account ?  '),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                      children: [
                        TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = widget.onClickedSignUp,
                          text: ('Sign Up'),
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Theme.of(context).colorScheme.secondary),
                        ),
                      ]),
                ),
                const SizedBox(height: 10),
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      color: Colors.purple.shade300,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                    text: ('App by Ponganan Saensuk'),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future signIn() async {
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      print(e);
      switch (e.code) {
        //Custom errors for Thai languages
        // switch (e.code) {case "xxxx error code xxxxx":}
        case "user-not-found":
          Utils.showSnackBar('?????????????????????????????????????????????');
          break;
        case "wrong-password":
          Utils.showSnackBar('??????????????????????????????????????????????????????');
          break;
        default:
          Utils.showSnackBar(e.message);
      }
      //Utils.showSnackBar(e.message);
    }

    //Navigator.of(context) not working
    // go to main_page.dart
    // add final navigatorKey = GlobalKey<NavigatorState>();  variable
    // and add navigatorKey: navigatorKey in MaterialApp
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}
