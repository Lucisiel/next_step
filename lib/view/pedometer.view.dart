import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:next_step/utils/global.configs.dart';
import 'package:next_step/view/form.view.dart';
import 'package:next_step/view/widgets/button.global.dart';
import 'package:next_step/view/widgets/sideBar.global.dart';
import 'package:sensors/sensors.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:next_step/functions/auth_service.dart';

class PedometerView extends StatefulWidget {
  const PedometerView({Key? key}) : super(key: key);

  @override
  PedometerViewState createState() => PedometerViewState();
}

class PedometerViewState extends State<PedometerView> {
  int _totalStepsCount = 0;
  int _stepsCount = 0;
  User? _user;

  // Constants based on average values
  final double averageStepLength = 0.762; // meters
  final double averageCaloriesBurnedPerStep = 0.05; // kcal

  // Calculate distance in kilometers
  double distanceInMeters = 0;
  double distanceInKm = 0;

  // Calculate calories burned
  double caloriesBurned = 0;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  late StreamSubscription<AccelerometerEvent> _accelerometerSubscription;

  @override
  void initState() {
    super.initState();
    validateCurrentUser();

    var initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    _accelerometerSubscription =
        accelerometerEvents.listen((AccelerometerEvent event) {
      setState(() {
        if (event.y > 11.0) {
          _stepsCount++;
          _totalStepsCount++;
          _updateUserStepCount();

          if (_stepsCount % 100 == 0) {
            _sendNotification();
          }
        }
      });
    });
  }

  @override
  void dispose() {
    _accelerometerSubscription.cancel(); // Cancel the subscription here
    super.dispose();
  }

  void validateCurrentUser() async {
    User? user = await AuthService.validateUser();
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
          Get.off(const FormView());
        } else {
          final currentDate =
              DateTime.now().toLocal().toString().substring(0, 10);
          final firebaseDate = userData.get('currentDate');

          if (firebaseDate != currentDate) {
            await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .update({
              'step': 0,
              'currentDate': currentDate,
            });

            setState(() {
              _stepsCount = 0;
            });
          } else {
            setState(() {
              _stepsCount = userData.get('step');
            });
          }
          setState(() {
            _user = user;
            _totalStepsCount = _totalStepsCount = userData.get('totalStep');
          });

          // Calculate distance in kilometers
          distanceInMeters = _stepsCount * averageStepLength;
          distanceInKm = distanceInMeters / 1000;

          // Calculate calories burned
          caloriesBurned = _stepsCount * averageCaloriesBurnedPerStep;
        }
      }
    } else {
      AuthService.showAlert();
    }
  }

  void _updateUserStepCount() async {
    var user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (userData.exists) {
        final currentDate =
            DateTime.now().toLocal().toString().substring(0, 10);
        final firebaseDate = userData.get('currentDate');

        if (firebaseDate != currentDate) {
          _stepsCount = 0;
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .update({
            'step': 0,
            'currentDate': currentDate,
          });
          Get.snackbar(
            'Pedometer',
            'Your step count has been reset to 0 because day changed.',
          );
        } else {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .update({'step': _stepsCount, 'totalStep': _totalStepsCount});
        }
      }
    }

    // Calculate distance in kilometers
    distanceInMeters = _stepsCount * averageStepLength;
    distanceInKm = distanceInMeters / 1000;

    // Calculate calories burned
    caloriesBurned = _stepsCount * averageCaloriesBurnedPerStep;
  }

  @override
  Widget build(BuildContext context) {
    return _user != null
        ? WillPopScope(
            onWillPop: () => _onWillPop(context),
            child: Scaffold(
              appBar: AppBar(
                title: const Text('Home'),
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 200,
                          height: 200,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              CircularProgressIndicator(
                                value: _stepsCount / 3000,
                                backgroundColor: Colors.grey[300],
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    GlobalConfigs.mainColor),
                                strokeWidth: 8,
                              ),
                              Center(
                                child: Text(
                                  _stepsCount.toString(),
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: GlobalConfigs.mainColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 50),
                        ButtonGlobal(
                            text: '$caloriesBurned kalori terbakar',
                            onPress: () => {}),
                        const SizedBox(height: 20),
                        ButtonGlobal(
                            text: '$distanceInMeters meters',
                            onPress: () => {}),
                        const SizedBox(height: 20),
                        ButtonGlobal(
                            text: '$distanceInKm kilometers',
                            onPress: () => {}),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        : const SizedBox.shrink();
  }

  Future<bool> _onWillPop(BuildContext context) async {
    return await Get.dialog<bool>(
          AlertDialog(
            title: const Text('Confirmation'),
            content: const Text('Are you sure to close this app?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Get.back(result: false),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () => SystemNavigator.pop(),
                child: const Text('Yes'),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<void> _sendNotification() async {
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );
    var platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0,
        'Hey!',
        'Don’t forget to drink during your walking exercise.',
        platformChannelSpecifics,
        payload: 'Default_Sound');
  }
}
