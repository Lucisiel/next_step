import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:next_step/utils/global.configs.dart';
import 'package:next_step/view/form.view.dart';
import 'package:next_step/view/login.view.dart';
import 'package:next_step/view/widgets/bottomBar.global.dart';
import 'package:next_step/view/widgets/button.global.dart';
import 'package:next_step/view/widgets/text.form.global.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
          'weight': null,
          'height': null,
          'gender': null,
          'birthday': null,
        });
        Get.to(const FormView());
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
      // print(e);
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
              crossAxisAlignment: CrossAxisAlignment.center,
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
                      controller: nameController,
                      text: 'Your name',
                      obscure: false,
                      textInputType: TextInputType.text,
                    ),
                    const SizedBox(height: 20),
                    TextFormGlobal(
                      controller: emailController,
                      text: 'Your email',
                      obscure: false,
                      textInputType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 20),
                    TextFormGlobal(
                      controller: passwordController,
                      text: 'Your password',
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
                    const SizedBox(height: 20),
                    InkWell(
                      onTap: () {
                        Get.off(() => LoginView());
                      },
                      child: const Text('Already have an account? Login'),
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
