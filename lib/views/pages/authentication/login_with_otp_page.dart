// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, avoid_unnecessary_containers

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:ssd_app/contollers/login_controller.dart';
import 'package:ssd_app/views/pages/authentication/registration_page.dart';
import 'package:ssd_app/views/widgets/authentication_top_widget.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import 'login_with_pw_page.dart';

class LogInWithOTPPage extends StatefulWidget {
  const LogInWithOTPPage({super.key});

  @override
  State<LogInWithOTPPage> createState() => _LogInWithOTPPageState();
}

class _LogInWithOTPPageState extends State<LogInWithOTPPage> {
  TextEditingController phoneController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final LoginController loginController = Get.find();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Obx(() {
          if (loginController.isLoading.isTrue) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return SingleChildScrollView(
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
                                }
                                if (value.length < 10) {
                                  return 'Invalid phone number';
                                }
                                return null;
                              },
                            ),
                            CustomButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  await loginController.sendOTP(
                                      mobile: phoneController.text);
                                  if (kDebugMode) {
                                    print("SEND OTP VALIDATED");
                                  }
                                }
                              },
                              text: "Send OTP",
                            ),
                            CustomButton(
                              onPressed: () {
                                Get.to(LoginWithPWPage());
                              },
                              text: "Login With Password",
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
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        }),
      ),
    );
  }
}
