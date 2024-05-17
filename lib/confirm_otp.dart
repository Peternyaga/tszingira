
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tsc_miti/confirm_otp_body.dart';
import 'constants.dart';
class ConfirmOTP extends StatelessWidget {
  ConfirmOTP({super.key});
  late SharedPreferences prefs;
  String tsc = tscNo;

  @override
  Widget build(BuildContext context) {
    FocusNode myFocusNode = FocusNode();
    myFocusNode.requestFocus();
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            "otp Confirmation",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
        ),
      ),
      body: const ConfirmOtpBody(),
    );
  }
}
