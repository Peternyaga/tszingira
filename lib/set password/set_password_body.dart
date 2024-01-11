import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:testproject/login/Login.dart';
import '../constants.dart';
import '../functions.dart';

class SetPasswordBody extends StatefulWidget {
  const SetPasswordBody({super.key});

  @override
  State<SetPasswordBody> createState() => _State();
}

class _State extends State<SetPasswordBody> {
  FocusNode passwordFocusNode = FocusNode();
  FocusNode confirmFocusNode = FocusNode();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  bool isLoading = false;

  void navigator(dynamic destination) {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => destination),
    );
  }

  Future<String> setPassword(String password, String tscNo) async {
    Map<String, String> data = {
      'password':password,
      'tsc_no':tscNo
    };

    try{
      var response = await http.post(
          Uri.parse(setPasswordURL),
          headers:<String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body:jsonEncode(data)
      );
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
    passwordFocusNode.requestFocus();
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  "Enter your password below.",
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
                      focusNode: passwordFocusNode,
                      controller: password,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  "Confirm your password below.",
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
                      focusNode: confirmFocusNode,
                      controller: confirmPassword,
                      textAlign: TextAlign.center,
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
              if(password.text.isNotEmpty){
                if(password.text==confirmPassword.text){

                }else{
                  toast("Your passwords do not match!");
                  confirmFocusNode.requestFocus();
                  confirmPassword.clear();
                }
              }else{
                toast("password cannot be empty!");
              }
              String response = await setPassword(password.text, tscNo);
              if(response=="1"){
                toast("success");
                navigator(const Login());
              }else if(response=="101"){
                toast("Incorrect OTP");
              }else if(response=="102"){
                toast("Invalid OTP");
              }else{
                toast("An error occurred. Please try again");
              }
            },
            child:
            isLoading
                ? const CircularProgressIndicator()
                : const Text(
              "set Password",
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
