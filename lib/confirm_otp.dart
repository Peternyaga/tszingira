import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'constants.dart';
class ConfirmOTP extends StatelessWidget {
  //const ConfirmOTP({super.key});
  late SharedPreferences prefs;
  String tsc = tscNo;
  Future<String> confirmOTP(String otp, String tscNo) async {
    Map<String, String> data = {
      'otp':otp,
      'tsc_no':tscNo
    };
    try{
      var response = await http.post(
        Uri.parse(confirmOTPURL),
        headers:<String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body:jsonEncode(data)
      );
      print(response.body);
      return response.body;
    }catch(e){
      return e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    FocusNode myFocusNode = FocusNode();
    myFocusNode.requestFocus();
    TextEditingController otp = TextEditingController();
    return Scaffold(
      backgroundColor: Colors.green[100],
      appBar: AppBar(
        backgroundColor: Colors.green[200],
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                    "Enter the OTP sent to your phone to create a password for your account.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      letterSpacing: 2,
                    ),
                  ),
                ),
                SizedBox(
                  width: 200.0, // Set width as desired
                  height: 50.0, // Set height as desired
                  child: Container(
                    color: Colors.white60,
                    child: Focus(
                      child: TextField(
                        focusNode: myFocusNode,
                        controller: otp,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 50.0,
            ),
            ElevatedButton(
              onPressed: () async {

                String response = confirmOTP(otp.text, tsc).toString();
                if (kDebugMode) {
                  print("tsc_no: $tsc");
                }
              },
              child: const Text(
                "confirm OTP",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
