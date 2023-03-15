import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:next_step/utils/global.colors.dart';
import 'package:next_step/view/widgets/button.global.dart';
import 'package:next_step/view/widgets/sidebar.global.dart';
import 'package:sensors/sensors.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login.view.dart';

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

  @override
  void initState() {
    super.initState();
    _validateUser();

    var initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);

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

  void _validateUser() async {
    final user = FirebaseAuth.instance.currentUser;
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
          _totalStepsCount = userData.get('totalStep');
        });
      }
    } else {
      Future.delayed(Duration.zero, () {
        _showAlert();
      });
    }

    // Calculate distance in kilometers
    distanceInMeters = _stepsCount * averageStepLength;
    distanceInKm = distanceInMeters / 1000;

    // Calculate calories burned
    caloriesBurned = _stepsCount * averageCaloriesBurnedPerStep;
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

  void _showAlert() {
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
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
          backgroundColor: GlobalColors.mainColor,
        ),
        drawer: const SidebarGlobal(),
        body: _user != null
            ? SafeArea(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 50),
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
                                  GlobalColors.mainColor),
                              strokeWidth: 8,
                            ),
                            Center(
                              child: Text(
                                _stepsCount.toString(),
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: GlobalColors.mainColor,
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
                          text: '$distanceInMeters meters', onPress: () => {}),
                      const SizedBox(height: 20),
                      ButtonGlobal(
                          text: '$distanceInKm kilometers', onPress: () => {}),
                    ],
                  ),
                ),
              )
            : const SizedBox.shrink(),
      ),
    );
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
                onPressed: () => Get.back(result: true),
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
