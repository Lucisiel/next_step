import 'package:flutter/material.dart';
import 'package:next_step/utils/global.configs.dart';
import 'widgets/sideBar.global.dart';

class BrowseView extends StatelessWidget {
  const BrowseView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Browse'),
        backgroundColor: GlobalConfigs.mainColor,
      ),
      drawer: const SideBarGlobal(),
      body: Center(
        child: Text(
          "Halaman Browse",
          style: TextStyle(
            color: GlobalConfigs.mainColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
