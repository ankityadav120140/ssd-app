// ignore_for_file: non_constant_identifier_names, prefer_const_constructors, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ssd_app/views/pages/home_page.dart';

import '../../consts/assets.dart';
import '../../contollers/login_controller.dart';
import '../../contollers/theme_controller.dart';

class HomeEndDrawer extends StatelessWidget {
  final LoginController loginController = Get.find();
  final ThemeController themeController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Obx(() {
        return Column(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(loginController.user.value!.name),
              accountEmail: Text(loginController.user.value!.mobile),
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage(LOGO),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Get.offAll(HomePage());
              },
            ),
            SwitchListTile(
              title: Text(themeController.isDarkMode.isTrue
                  ? 'Dark Mode'
                  : 'Light Mode'),
              value: themeController.isDarkMode.value,
              onChanged: (value) {
                themeController.toggleTheme();
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () async {
                await loginController.logOut();
              },
            ),
          ],
        );
      }),
    );
  }
}
