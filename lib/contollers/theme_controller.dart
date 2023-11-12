import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  RxBool isDarkMode = false.obs;
  @override
  void onInit() {
    super.onInit();
    isDarkMode.value = Get.isPlatformDarkMode;
  }

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    updateTheme();
  }

  void updateTheme() {
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
    // Get.changeTheme(isDarkMode.value ? ThemeData.dark() : ThemeData.light());
  }
}
