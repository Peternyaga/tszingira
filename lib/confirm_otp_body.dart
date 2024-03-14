import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:testproject/set%20password/create_password.dart';
import 'constants.dart';
import 'functions.dart';


class ConfirmOtpBody extends StatefulWidget {
  const ConfirmOtpBody({super.key});

  @override
  State<ConfirmOtpBody> createState() => _ConfirmOtpBodyState();
}

class _ConfirmOtpBodyState extends State<ConfirmOtpBody> {
  FocusNode myFocusNode = FocusNode();
  TextEditingController otp = TextEditingController();
  bool isLoading = false;
  Future<SharedPreferences> prefs=SharedPreferences.getInstance();
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
      if (response.body == "0"){
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SetPassword()),
        );
      }
      setState(() {
        isLoading = false;
      });
      print(response.body);
      return response.body;
    }catch(e){
      return e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    myFocusNode.requestFocus();
    return Center(
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
            onPressed:
                isLoading ? null
                    :() async {
              setState(() {
                isLoading = true;
              });
              String response = await confirmOTP(otp.text, tsc);
              if(response=="0"){
                toast("success");
              }else if(response=="101"){
                toast("Incorrect OTP");
              }else if(response=="102"){
                toast("Invalid OTP");
              }else{
                toast("An error occurred. Please try again");
              }
              if (kDebugMode) {
                print("tsc_no: $tsc");
              }
            },
            child:
            isLoading
                ? const CircularProgressIndicator()
                : const Text(
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
    );
  }
}
