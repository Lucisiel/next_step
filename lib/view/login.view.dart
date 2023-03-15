import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:next_step/view/pedometer.view.dart';
import 'package:next_step/view/widgets/button.global.dart';
import 'package:next_step/view/widgets/text.form.global.dart';
import 'register.view.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginView extends StatelessWidget {
  LoginView({super.key});
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final auth = FirebaseAuth.instance;

  Future<void> login() async {
    final String email = emailController.text.trim();
    final String password = passwordController.text.trim();

    if (email.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter your email.',
      );
      return;
    }

    if (password.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter your password',
      );
      return;
    }

    if (password.length < 8) {
      Get.snackbar(
        'Error',
        'Password should be at least 8 characters long.',
      );
      return;
    }

    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      Get.to(const PedometerView());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Get.snackbar(
          'Error',
          'No user found for that email.',
        );
      } else if (e.code == 'wrong-password') {
        Get.snackbar(
          'Error',
          'Wrong password provided for that user.',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                Container(
                  alignment: Alignment.center,
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: 160,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Walk for health.",
                  style: TextStyle(
                    color: Color(0xff6a6a6a),
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 40),
                Column(
                  children: [
                    const SizedBox(
                      height: 20,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Your email address",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormGlobal(
                      controller: emailController,
                      text: 'Email',
                      obscure: false,
                      textInputType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 20),
                    const SizedBox(
                      height: 20,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Your password",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormGlobal(
                      controller: passwordController,
                      text: 'Password',
                      obscure: true,
                      textInputType: TextInputType.text,
                    ),
                    const SizedBox(height: 20),
                    ButtonGlobal(
                        text: 'Login',
                        onPress: () {
                          login();
                        }),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 50,
        color: Colors.white,
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                Get.to(RegisterView());
              },
              child: const Text('Don\'t have an account? Register'),
            )
          ],
        ),
      ),
    );
  }
}
