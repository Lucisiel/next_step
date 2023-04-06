import 'package:flutter/material.dart';
import 'package:next_step/utils/global.configs.dart';
import 'widgets/sideBar.global.dart';

class JournalView extends StatelessWidget {
  const JournalView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Journal'),
        backgroundColor: GlobalConfigs.mainColor,
      ),
      drawer: const SideBarGlobal(),
      body: Center(
        child: Text(
          "Halaman Journal",
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
