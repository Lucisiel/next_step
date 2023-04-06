import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'login.view.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    Timer(const Duration(seconds: 1), () {
      Get.off(LoginView());
    });
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Image.asset('assets/images/logo.png', width: 160),
        ));
  }
}
