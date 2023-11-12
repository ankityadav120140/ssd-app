// ignore_for_file: prefer_interpolation_to_compose_strings, avoid_print, prefer_const_constructors, await_only_futures

import 'package:get/get.dart';
import 'package:ssd_app/services/database_helper.dart';
import 'package:ssd_app/views/pages/authentication/login_with_otp_page.dart';
import 'package:ssd_app/views/pages/home_page.dart';
import '../models/user.dart';
import '../services/login_services.dart';

class LoginController extends GetxController {
  final LoginService _loginService = LoginService();
  RxBool isLoading = false.obs;
  RxString userId = ''.obs;
  final user = Rx<User?>(null);

  @override
  Future<void> onInit() async {
    await isLoggedIn();
    super.onInit();
  }

  isLoggedIn() async {
    final dbHelper = DatabaseHelper();
    try {
      final User? foundUser = await dbHelper.getUser();
      user.value = foundUser;
      userId.value = foundUser!.id;
      if (userId.isNotEmpty) {
        
      }
    } catch (e) {
      userId.value = '';
    }
  }

  Future<void> loginWithPassword(
      {String mobile = "7773854345", String password = "123456"}) async {
    try {
      isLoading(true);

      final loggedInUser =
          await _loginService.loginWithPassword(mobile, password);

      if (loggedInUser != null) {
        user.value = loggedInUser;
        userId.value = loggedInUser.id;
        final dbHelper = DatabaseHelper();
        await dbHelper.insertUser(loggedInUser);
        await isLoggedIn();
        Get.offAll(HomePage());
      }
    } catch (error) {
      print(error);
    } finally {
      isLoading(false);
    }
  }

  Future<void> sendOTP({String mobile = "7773854345"}) async {
    try {
      isLoading(true);
      await _loginService.sendOTP(mobile);
    } catch (error) {
      print(error);
    } finally {
      isLoading(false);
    }
  }

  Future<void> verifyOTP(
      {String mobile = "7773854345", String otp = "1111"}) async {
    try {
      isLoading(true);

      final loggedInUser = await _loginService.verifyOTP(mobile, otp);

      if (loggedInUser != null) {
        await isLoggedIn();
        userId.value = loggedInUser.id;
        final dbHelper = DatabaseHelper();
        await dbHelper.insertUser(loggedInUser);
        Get.offAll(HomePage());
      }
    } catch (error) {
      print("Login Error : " + error.toString());
    } finally {
      isLoading(false);
    }
  }

  Future<void> logOut() async {
    try {
      isLoading(true);
      final dbHelper = DatabaseHelper();
      await dbHelper.deleteUser(userId.value);
      userId.value = '';
      Get.offAll(LogInWithOTPPage());
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }
}
