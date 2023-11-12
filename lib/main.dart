// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, unused_local_variable, must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:ssd_app/contollers/connectivity_controller.dart';
import 'package:ssd_app/contollers/login_controller.dart';
import 'package:ssd_app/contollers/theme_controller.dart';
import 'consts/globals.dart';
import 'services/database_helper.dart';
import 'views/pages/authentication/login_with_otp_page.dart';
import 'views/pages/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GLOBAL_DATABASE = await DatabaseHelper.instance.database;
  final loginController = Get.put(LoginController());
  Get.put(ConnectivityController());
  Get.put(ThemeController());
  await loginController.isLoggedIn();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  LoginController loginController = Get.find();

  @override
  Widget build(BuildContext context) {
    final isUserLoggedIn = loginController.userId.value != '';
    ThemeController themeController = Get.find();

    return Sizer(builder: (context, orientation, deviceType) {
      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'SSD App',
        theme: ThemeData(useMaterial3: true),
        darkTheme: ThemeData.dark(useMaterial3: true),
        home: isUserLoggedIn ? HomePage() : LogInWithOTPPage(),
      );
    });
  }
}
