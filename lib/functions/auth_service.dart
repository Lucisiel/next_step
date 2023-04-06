import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:next_step/view/login.view.dart';

class AuthService {
  static Future<User?> validateUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (userData.exists) {
        return user;
      }
    }
    return null;
  }

  static void showAlert() {
    Future.delayed(Duration.zero, () {
      Get.defaultDialog(
        title: 'Login Required',
        middleText: 'Please log in to access this page.',
        actions: [
          TextButton(
            onPressed: () {
              Get.to(LoginView());
            },
            child: const Text('OK'),
          ),
        ],
      );
    });
  }
}
