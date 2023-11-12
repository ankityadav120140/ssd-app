// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors_in_immutables, library_private_types_in_public_api, prefer_const_constructors, must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PasswordField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;

  PasswordField({
    required this.controller,
    required this.labelText,
    required this.hintText,
  });

  var obscureText = true.obs;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return TextFormField(
        obscureText: obscureText.isTrue,
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          border: OutlineInputBorder(),
          suffixIcon: IconButton(
            icon: Icon(
              obscureText.isFalse ? Icons.visibility : Icons.visibility_off,
              color: Colors.grey,
            ),
            onPressed: () {
              obscureText.toggle();
            },
          ),
        ),
        keyboardType: TextInputType.text,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Password is required';
          }
          return null;
        },
      );
    });
  }
}
