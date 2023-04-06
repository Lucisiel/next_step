import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:next_step/utils/global.configs.dart';
import 'package:next_step/view/browse.view.dart';
import 'package:next_step/view/profile.view.dart';
import 'package:next_step/view/journal.view.dart';
import 'package:next_step/view/login.view.dart';
import 'package:next_step/view/pedometer.view.dart';

class SideBarGlobal extends StatelessWidget {
  const SideBarGlobal({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            buildHeader(context),
            buildMenuItems(context),
          ],
        ),
      ),
    );
  }

  Widget buildHeader(BuildContext context) => Container(
      color: GlobalConfigs.mainColor,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
      ));

  Widget buildMenuItems(BuildContext context) => Container(
        padding: const EdgeInsets.all(24),
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.home_outlined),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
                Get.to(const PedometerView());
              },
            ),
            ListTile(
              leading: const Icon(Icons.info_outlined),
              title: const Text('Journal'),
              onTap: () {
                Navigator.pop(context);
                Get.to(const JournalView());
              },
            ),
            ListTile(
              leading: const Icon(Icons.search_outlined),
              title: const Text('Browse'),
              onTap: () {
                Navigator.pop(context);
                Get.to(const BrowseView());
              },
            ),
            ListTile(
              leading: const Icon(Icons.person_outlined),
              title: const Text('Profile'),
              onTap: () {
                Navigator.pop(context);
                Get.to(const ProfileView());
              },
            ),
            const Divider(
              color: Colors.black54,
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app_outlined),
              title: const Text('Logout'),
              onTap: () {
                Get.dialog(
                  AlertDialog(
                    title: const Text('Confirmation'),
                    content: const Text('Are you sure you want to log out?'),
                    actions: [
                      TextButton(
                        onPressed: () => Get.back(),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () async {
                          await FirebaseAuth.instance.signOut();
                          Get.off(LoginView());
                        },
                        child: const Text('Log Out'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      );
}
