// ignore_for_file: prefer_const_declarations

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:ssd_app/consts/constant.dart';
import 'package:ssd_app/views/widgets/otp_verification_dialogue.dart';
import '../models/user.dart';

class LoginService {
  final Dio _dio = Dio();

  Future<User?> loginWithPassword(String mobile, String password) async {
    try {
      final url = '${BASE_URL}customer/customer-app-login';

      final response = await _dio.post(url, data: {
        'mobile': mobile,
        'password': password,
      });

      if (response.statusCode == 200) {
        final userData = response.data['data'];
        final loggedInUser = User.fromJson(userData);
        return loggedInUser;
      } else {
        final error = response.data['message'] ?? 'Login failed';
        throw error.toString();
      }
    } on DioException catch (e) {
      if (e.response!.data['message'] == 'errors') {
        String errorKey = e.response!.data['errors_keys'][0].toString();
        Get.snackbar(
            'Error', e.response!.data['errors'][errorKey][0].toString());
      } else {
        Get.snackbar('Error', e.response!.data['message'].toString());
      }
    } catch (e) {
      throw e.toString();
    }
    return null;
  }

  Future<void> sendOTP(String mobile) async {
    try {
      final url = '${BASE_URL}customer/login-with-otp';

      final response = await _dio.post(url, data: {
        'mobile': mobile,
      });

      if (response.statusCode == 200) {
        Get.dialog(OTPInputDialog(mobile: mobile));
      } else {
        final error = response.data['message'] ?? 'Login failed';
        throw error.toString();
      }
    } on DioException catch (e) {
      if (e.response!.data['message'] == 'errors') {
        String errorKey = e.response!.data['errors_keys'][0].toString();
        Get.snackbar(
            'Error', e.response!.data['errors'][errorKey][0].toString());
      } else {
        Get.snackbar('Error', e.response!.data['message'].toString());
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<User?> verifyOTP(String mobile, String otp) async {
    try {
      final url = '${BASE_URL}customer/customer-app-verify-otp';

      final response = await _dio.post(url, data: {
        'mobile': mobile,
        'otp': otp,
      });

      if (response.statusCode == 200) {
        final userData = response.data['data'];
        final loggedInUser = User.fromJson(userData);
        return loggedInUser;
      } else {
        final error = response.data['message'] ?? 'Login failed';
        throw error.toString();
      }
    } on DioException catch (e) {
      if (e.response!.data['message'] == 'errors') {
        String errorKey = e.response!.data['errors_keys'][0].toString();
        Get.snackbar(
            'Error', e.response!.data['errors'][errorKey][0].toString());
      } else {
        Get.snackbar('Error', e.response!.data['message'].toString());
      }
    } catch (e) {
      throw e.toString();
    }
    return null;
  }
}
