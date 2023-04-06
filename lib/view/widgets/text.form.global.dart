import 'package:flutter/material.dart';
import 'package:next_step/utils/global.configs.dart';

class TextFormGlobal extends StatelessWidget {
  const TextFormGlobal({
    super.key,
    required this.text,
    required this.controller,
    required this.textInputType,
    required this.obscure,
  });
  final TextEditingController controller;
  final String text;
  final TextInputType textInputType;
  final bool obscure;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 20,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              text,
              style: TextStyle(
                color: GlobalConfigs.mainColor,
                fontSize: GlobalConfigs.textBodySize,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          height: 50,
          padding: const EdgeInsets.only(
            left: 15,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(50),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 7,
              ),
            ],
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: textInputType,
            readOnly: textInputType == TextInputType.datetime,
            obscureText: obscure,
            decoration: InputDecoration(
              hintText: text,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(0),
              hintStyle: const TextStyle(
                height: 1,
              ),
            ),
            onTap: () async {
              if (textInputType == TextInputType.datetime) {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime(2100),
                );
                if (pickedDate != null) {
                  String formattedDate =
                      "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
                  controller.text = formattedDate;
                }
              }
            },
          ),
        ),
      ],
    );
  }
}
