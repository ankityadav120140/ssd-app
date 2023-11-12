// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:ssd_app/contollers/login_controller.dart';
import 'package:ssd_app/views/pages/authentication/registration_page.dart';
import '../../widgets/authentication_top_widget.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/password_field.dart';

class LoginWithPWPage extends StatefulWidget {
  const LoginWithPWPage({super.key});

  @override
  State<LoginWithPWPage> createState() => _LoginWithPWPageState();
}

class _LoginWithPWPageState extends State<LoginWithPWPage> {
  TextEditingController phoneController = TextEditingController();
  TextEditingController pwController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  LoginController loginController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Obx(() {
        return SafeArea(
          child: loginController.isLoading.isTrue
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AuthTopWidget(),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 5.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Please Log In",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15.sp,
                              ),
                            ),
                            SizedBox(height: 1.h),
                            Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  CustomTextField(
                                    controller: phoneController,
                                    labelText: 'Phone No.',
                                    hintText: 'Enter your phone number',
                                    keyboardType: TextInputType.phone,
                                    maxLength: 10,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Phone No. is required';
                                      } else if (value.length != 10) {
                                        return 'Invalid phone number';
                                      } else {
                                        return null;
                                      }
                                    },
                                  ),
                                  SizedBox(height: 0.5.h),
                                  PasswordField(
                                    controller: pwController,
                                    labelText: 'Password',
                                    hintText: 'Enter your password',
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      TextButton(
                                        onPressed: () {},
                                        child: Text(
                                          "Forgot Password?",
                                        ),
                                      ),
                                    ],
                                  ),
                                  CustomButton(
                                    onPressed: () async {
                                      if (_formKey.currentState!.validate()) {
                                        await loginController.loginWithPassword(
                                          mobile: phoneController.text,
                                          password: pwController.text,
                                        );
                                      }
                                    },
                                    text: "Login",
                                  ),
                                  CustomButton(
                                    onPressed: () {
                                      Get.back();
                                    },
                                    text: "Login With OTP",
                                  ),
                                  SizedBox(height: 1.h),
                                  Divider(),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("Not a member already?"),
                                      TextButton(
                                          onPressed: () {
                                            Get.to(RegistrationPage());
                                          },
                                          child: Text("Register"))
                                    ],
                                  ),
                                  SizedBox(height: 1.h),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
        );
      }),
    );
  }
}
