import 'package:flutter/material.dart';

class BottomBarGlobal extends StatelessWidget {
  const BottomBarGlobal({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      color: Colors.white,
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text('Copyright © 2023 by Achai'),
        ],
      ),
    );
  } 
}
