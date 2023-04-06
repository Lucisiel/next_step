import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:next_step/utils/global.configs.dart';
import 'package:next_step/view/form.view.dart';
import 'package:next_step/view/pedometer.view.dart';
import 'package:next_step/view/register.view.dart';
import 'package:next_step/view/widgets/bottomBar.global.dart';
import 'package:next_step/view/widgets/button.global.dart';
import 'package:next_step/view/widgets/text.form.global.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
        email: email,
        password: password,
      );
      User? user = userCredential.user;

      if (user != null) {
        final userData = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userData.exists) {
          if (userData.get('weight') == null ||
              userData.get('height') == null ||
              userData.get('gender') == null ||
              userData.get('birthday') == null) {
            // Redirect to the FormView
            Get.to(const FormView());
          } else {
            Get.off(const PedometerView());
          }
        }
      }
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
        physics: const BouncingScrollPhysics(),
        child: SafeArea(
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(GlobalConfigs.paddingBody),
            child: Column(
              children: [
                const SizedBox(height: 16),
                Container(
                  alignment: Alignment.center,
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: 160,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Walk for health.",
                  style: TextStyle(
                    color: GlobalConfigs.textColor,
                    fontSize: GlobalConfigs.textBodySize,
                  ),
                ),
                const SizedBox(height: 40),
                Column(
                  children: [
                    TextFormGlobal(
                      controller: emailController,
                      text: 'Your email address',
                      obscure: false,
                      textInputType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 20),
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
                    const SizedBox(height: 20),
                    InkWell(
                      onTap: () {
                        Get.off(() => RegisterView());
                      },
                      child: const Text('Don\'t have an account? Register'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const BottomBarGlobal(),
    );
  }
}
