import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:next_step/utils/global.configs.dart';
import 'package:next_step/view/pedometer.view.dart';
import 'package:next_step/view/widgets/bottomBar.global.dart';
import 'package:next_step/view/widgets/button.global.dart';
import 'package:next_step/view/widgets/contact.global.dart';
import 'package:next_step/view/widgets/text.form.global.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:next_step/functions/auth_service.dart';

class FormView extends StatefulWidget {
  const FormView({Key? key}) : super(key: key);

  @override
  FormViewState createState() => FormViewState();
}

class FormViewState extends State<FormView> {
  User? _user;

  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController birthdayController = TextEditingController();

  @override
  void initState() {
    super.initState();
    validateCurrentUser();
  }

  void validateCurrentUser() async {
    User? user = await AuthService.validateUser();
    if (user == null) {
      AuthService.showAlert();
    } else {
      setState(() {
        _user = user;
      });
    }
  }

  Future<void> finishRegister() async {
    final String weight = weightController.text.trim();
    final String height = heightController.text.trim();
    final String gender = genderController.text.trim();
    final String birthday = birthdayController.text.trim();

    if (weight.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter your weight.',
      );
      return;
    }

    if (height.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter your height.',
      );
      return;
    }

    if (gender.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter your gender.',
      );
      return;
    }

    if (birthday.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter your birthday.',
      );
      return;
    }

    User? user = _user;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
        'weight': weight,
        'height': height,
        'gender': gender,
        'birthday': birthday,
      });
      Get.to(const PedometerView());
    }
  }

  @override
  Widget build(BuildContext context) {
    return _user != null
        ? Scaffold(
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
                      Text(
                        "Please enter your data, so we can calculate your walking exercise.",
                        style: TextStyle(
                          color: GlobalConfigs.textColor,
                          fontSize: GlobalConfigs.textBodySize,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: TextFormGlobal(
                                  controller: weightController,
                                  text: 'Weight (kg)',
                                  obscure: false,
                                  textInputType: TextInputType.number,
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: TextFormGlobal(
                                  controller: heightController,
                                  text: 'Height (cm)',
                                  obscure: false,
                                  textInputType: TextInputType.number,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormGlobal(
                                  controller: genderController,
                                  text: 'Gender',
                                  obscure: false,
                                  textInputType: TextInputType.text,
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: TextFormGlobal(
                                  controller: birthdayController,
                                  text: 'Birthday',
                                  obscure: false,
                                  textInputType: TextInputType.datetime,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          ButtonGlobal(
                              text: 'Finish Register',
                              onPress: () {
                                finishRegister();
                              }),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const ContactGlobal(),
                    ],
                  ),
                ),
              ),
            ),
            bottomNavigationBar: const BottomBarGlobal(),
          )
        : const SizedBox.shrink();
  }
}
