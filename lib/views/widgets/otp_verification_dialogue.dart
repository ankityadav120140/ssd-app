// ignore_for_file: must_be_immutable, prefer_const_constructors, library_private_types_in_public_api, unrelated_type_equality_checks, avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ssd_app/contollers/login_controller.dart';

class OTPInputDialog extends StatefulWidget {
  OTPInputDialog({required this.mobile, super.key});
  String mobile;

  @override
  _OTPInputDialogState createState() => _OTPInputDialogState();
}

class _OTPInputDialogState extends State<OTPInputDialog> {
  final TextEditingController otpController = TextEditingController();
  LoginController loginController = Get.find();
  final countdownTimer = RxInt(120).obs;
  var showResendButton = false.obs;

  Stream<RxInt> countdownStream() {
    return Stream.periodic(Duration(seconds: 1), (i) {
      return countdownTimer.value - 1;
    }).takeWhile((remainingTime) => remainingTime >= 0);
  }

  @override
  void initState() {
    countdownStream().listen((remainingTime) {
      countdownTimer.value = remainingTime;
      if (remainingTime == 0) {
        showResendButton(true);
      }
    });
    super.initState();
  }

  void startTimer() {
    setState(() {
      showResendButton(false);
      countdownTimer.value(120);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Enter OTP"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            controller: otpController,
            decoration: InputDecoration(labelText: 'OTP'),
          ),
          SizedBox(height: 16.0),
          showResendButton.isTrue
              ? ElevatedButton(
                  onPressed: () {
                    loginController.sendOTP(
                      mobile: widget.mobile,
                    );
                    startTimer();
                  },
                  child: Text('Resend OTP'),
                )
              : Obx(
                  () {
                    if (countdownTimer.value > 0) {
                      return Text(
                        'Resend OTP in ${countdownTimer.value} seconds',
                        style: TextStyle(fontSize: 16.0),
                      );
                    } else {
                      return ElevatedButton(
                        onPressed: () {
                          loginController.sendOTP(
                            mobile: widget.mobile,
                          );
                          startTimer();
                        },
                        child: Text('Resend OTP'),
                      );
                    }
                  },
                ),
        ],
      ),
      actions: <Widget>[
        Center(
          child: ElevatedButton(
            onPressed: () async {
              String otp = otpController.text;
              print("Verify OTP: $otp");
              await loginController.verifyOTP(
                mobile: widget.mobile,
                otp: otpController.text,
              );
              Get.back();
            },
            child: Text('Verify'),
          ),
        ),
      ],
    );
  }
}
