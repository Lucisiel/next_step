import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:next_step/utils/global.configs.dart';
import 'package:next_step/view/widgets/button.global.dart';
import 'package:next_step/view/widgets/text.form.global.dart';
import 'widgets/sideBar.global.dart';
import 'package:next_step/functions/auth_service.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  ProfileViewState createState() => ProfileViewState();

  // name
  // email
  // weight
  // height
  // gender
  // birthday
}

class ProfileViewState extends State<ProfileView> {
  User? _user;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
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
      final userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (userData.exists) {
        nameController.text = userData.get('name');
        weightController.text = userData.get('weight');
        heightController.text = userData.get('height');
        genderController.text = userData.get('gender');
        birthdayController.text = userData.get('birthday');
        emailController.text = user.email ?? "";
        setState(() {
          _user = user;
        });
      }
    }
  }

  Future<void> updateProfile() async {
    final String name = nameController.text.trim();
    final String email = emailController.text.trim();
    final String weight = weightController.text.trim();
    final String height = heightController.text.trim();
    final String gender = genderController.text.trim();
    final String birthday = birthdayController.text.trim();

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
      await user.updateEmail(email);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
        'name': name,
        'weight': weight,
        'height': height,
        'gender': gender,
        'birthday': birthday,
      });
      Get.snackbar(
        'Success',
        'You just updated your profile.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: GlobalConfigs.mainColor,
      ),
      drawer: const SideBarGlobal(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: SafeArea(
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(GlobalConfigs.paddingBody),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Text(
                  'Profile',
                  style: TextStyle(
                    color: GlobalConfigs.mainColor,
                    fontSize: 32,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Here is your profile data',
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
                      text: 'Name',
                      obscure: false,
                      textInputType: TextInputType.text,
                    ),
                    const SizedBox(height: 20),
                    TextFormGlobal(
                      controller: emailController,
                      text: 'Email',
                      obscure: false,
                      textInputType: TextInputType.text,
                    ),
                    const SizedBox(height: 20),
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
                        text: 'Update Profile',
                        onPress: () {
                          updateProfile();
                        }),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
