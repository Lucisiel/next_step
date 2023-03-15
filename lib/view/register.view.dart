import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:next_step/view/widgets/button.global.dart';
import 'package:next_step/view/widgets/text.form.global.dart';
import 'login.view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'pedometer.view.dart';

class RegisterView extends StatelessWidget {
  RegisterView({super.key});
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;

  Future<void> register() async {
    final String email = emailController.text.trim();
    final String password = passwordController.text.trim();
    final String name = nameController.text.trim();

    if (name.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter your name.',
      );
      return;
    }

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
        'Please enter your password.',
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
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;
      if (user != null) {
        final now = DateTime.now();
        final date = "${now.year}-${now.month}-${now.day}";

        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'name': name,
          'step': 0,
          'totalStep': 0,
          'currentDate': date,
        });
        Get.to(const PedometerView());
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Get.snackbar(
          'Error',
          'The password provided is too weak.',
        );
      } else if (e.code == 'email-already-in-use') {
        Get.snackbar(
          'Error',
          'The account already exists for that email.',
        );
      }
    } catch (e) {
      print(e);
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
                          "Your name",
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
                      controller: nameController,
                      text: 'Example Name',
                      obscure: false,
                      textInputType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 20),
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
                      text: 'example@example.com',
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
                      text: 'Register',
                      onPress: () {
                        register();
                      },
                    ),
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
                Get.to(LoginView());
              },
              child: const Text('Already have an account? Login'),
            )
          ],
        ),
      ),
    );
  }
}
