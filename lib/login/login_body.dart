import 'package:flutter/material.dart';
import 'package:testproject/account%20activation.dart';
import 'package:testproject/home.dart';

import '../constants.dart';
import '../functions.dart';


class LoginBody extends StatefulWidget {
  const LoginBody({super.key});

  @override
  State<LoginBody> createState() => _LoginBodyState();
}

class _LoginBodyState extends State<LoginBody> {
  FocusNode tscNoFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  TextEditingController tscNoEditor = TextEditingController();
  TextEditingController passwordEditor = TextEditingController();
  bool isLoading = false;

  void callNavigator(dynamic destination, bool pop){
    navigator(destination, context, pop);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  "Enter your TSC No. below.",
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
                      focusNode: tscNoFocusNode,
                      controller: tscNoEditor,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ),
              ),
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
                      controller: passwordEditor,
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
              if(tscNoEditor.text.isNotEmpty && passwordEditor.text.isNotEmpty) {
                setState(() {
                  isLoading = true;
                });
                Map data = {
                  'tsc_no': tscNoEditor.text,
                  'password': passwordEditor.text
                };
                String response = await postStringRequest(data, loginURL);
                setState(() {
                  isLoading = false;
                });
                if(response=="0"){
                  toast("success");
                  tscNo = tscNoEditor.text;
                  callNavigator(const Home(), true);
                }else if(response=="110") {
                  toast("Incorrect password");
                }else{
                  toast("An error occurred. Please try again");
                }
              }else{
                toast("All fields are required");
              }

            },
            child:
            isLoading
                ? const CircularProgressIndicator()
                : const Text(
              "login",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          ),
          const SizedBox(height: 70,),
          TextButton(onPressed: (){
            navigator(const Activation(), context, true);
          }, child: const Text("Activate Account"))
        ],
      ),
    );

  }
  }

