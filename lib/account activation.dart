import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:tsc_miti/confirm_otp.dart';
import 'package:tsc_miti/constants.dart';
import 'package:tsc_miti/login/Login.dart';

import 'functions.dart';


class Activation extends StatefulWidget {
  const Activation({super.key});

  @override
  State<Activation> createState() => _ActivationState();
}

class _ActivationState extends State<Activation> {
  bool isLoading = false;
  final TextEditingController tscNoController = TextEditingController();
  final TextEditingController phone = TextEditingController();
  Future<String> activateAccount(String tscNo, String phone) async {
    final Map<String, dynamic> data = {
      'tsc_no': tscNo,
      'phone': phone,
      "api_key": const String.fromEnvironment('TSC_API_KEY')
    };
    try {
      var response = await http.post(
            Uri.parse(accountActivationURL),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(data),
          );
      print(response.body);
        return response.body;
    } catch (e) {
      print(e.toString());
      return "112";
    }
  }

  void callNavigator(var dest, bool pop){
    navigator(dest, context,pop);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            "Account activation",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
        ),
      ),
      body: Card(
        child: Padding(
          padding: const EdgeInsets.all(50.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(), // Creates rounded borders
                    labelText: 'TSC NO.',
                  ),// Optional label text
                  controller: tscNoController,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                  ],
                ),
                const SizedBox(
                  height: 50.0,
                ),
                TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(), // Creates rounded borders
                    labelText: 'PHONE',
                  ),// Optional label text
                  controller: phone,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                  ],
                ),
                const SizedBox(
                  height: 50.0,
                ),
                ElevatedButton(
                  onPressed: () async {
                    if(tscNoController.text.isNotEmpty && phone.text.isNotEmpty){
                      setState(() {
                        isLoading = true;
                      });
                      String response =  await activateAccount(tscNoController.text, phone.text.trim());
                      setState(() {
                        isLoading = false;
                      });
                      if(response == "112"){
                        return toast("connection was interrupted");
                      }
                      try {
                        Map map = jsonDecode(response);
                        if (map['code'] == 0) {
                          tscNo = tscNoController.text.trim();
                          callNavigator(ConfirmOTP(), true);
                        } else {
                          toast(map['message']);
                        }
                      } catch (e) {
                        print(e);
                        toast("an error occured");
                      }
                    } else {
                      return toast("all fields are required");
                    }
                  },
                  child: Builder(builder: (context) {
                    if (isLoading) {
                      return const CircularProgressIndicator(
                        color: Colors.green,
                      );
                    } else {
                      return const Text(
                        "activate",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                        );
                      }

                    }
                  ),
                ),
                const SizedBox(height: 70,),
                TextButton(onPressed: (){
                  navigator(const Login(), context, true);
                }, child: const Text("login"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
