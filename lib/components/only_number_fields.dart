import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NumberTextFields extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String? hintText;
  final IconData? nameIcon;

  const NumberTextFields(
      {Key? key, required this.controller,
        required this.labelText,
        this.hintText,
        this.nameIcon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
        child: TextField(
          controller: controller,
          style: const TextStyle(fontSize: 24.0),
          decoration: InputDecoration(
              labelText: labelText,
              hintText: hintText,
              icon: nameIcon != null ? Icon(nameIcon) : null),
          keyboardType: TextInputType.number,
        ));
  }
}