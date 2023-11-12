// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:ssd_app/views/pages/authentication/login_with_otp_page.dart';
import 'package:ssd_app/views/widgets/authentication_top_widget.dart';
import 'package:ssd_app/views/widgets/custom_button.dart';
import 'package:ssd_app/views/widgets/custom_text_field.dart';
import 'package:ssd_app/views/widgets/password_field.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController pwController = TextEditingController();
  TextEditingController confirmPwController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              AuthTopWidget(),
              Form(
                key: _formKey,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  child: Column(
                    children: [
                      CustomTextField(
                        controller: nameController,
                        labelText: "Full Name",
                        hintText: "Please enter your full name",
                        keyboardType: TextInputType.name,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter your name";
                          }
                          return "";
                        },
                      ),
                      SizedBox(height: 1.h),
                      CustomTextField(
                        controller: phoneController,
                        labelText: 'Phone No.',
                        hintText: 'Enter your phone number',
                        keyboardType: TextInputType.phone,
                        maxLength: 10,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Phone No. is required';
                          }
                          if (value.length < 10) {
                            return 'Invalid phone number';
                          }
                          return "";
                        },
                      ),
                      PasswordField(
                        controller: pwController,
                        labelText: 'Password',
                        hintText: 'Enter your password',
                      ),
                      SizedBox(height: 1.h),
                      PasswordField(
                        controller: confirmPwController,
                        labelText: 'Confirm Password',
                        hintText: 'Re-enter your password',
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 1.h),
              CustomButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {}
                },
                text: "Register",
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already a member?"),
                  TextButton(
                      onPressed: () {
                        Get.off(LogInWithOTPPage());
                      },
                      child: Text("Log In"))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
