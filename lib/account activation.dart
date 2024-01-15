import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:testproject/confirm_otp.dart';
import 'package:testproject/constants.dart';
import 'package:testproject/login/Login.dart';

import 'functions.dart';


class Activation extends StatelessWidget {
  const Activation({super.key});

  Future<String> activate(String tscNo, String idNo) async {
    final Map<String, dynamic> data = {
      'tsc_no': tscNo,
      'id_no': idNo,
    };
    try {
      var response = await http.post(
            Uri.parse(accountActivationURL),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(data),
          );

      if (response.statusCode == 200) {
        toast('Post created successfully!');
        return response.statusCode.toString();
      } else {
        return response.statusCode.toString();
      }
    } catch (e) {
      return e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController tscNoController = TextEditingController();
    final TextEditingController idNo = TextEditingController();
    return Scaffold(
      backgroundColor: Colors.green[100],
      appBar: AppBar(
        backgroundColor: Colors.green[200],
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              children: [
                const Text(
                  "TSC number",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                SizedBox(
                  width: 200.0, // Set width as desired
                  height: 50.0, // Set height as desired
                  child: TextField(
                    controller: tscNoController,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 50.0,
            ),
            Column(
              children: [
                const Text(
                  "ID number",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                SizedBox(
                  width: 200.0, // Set width as desired
                  height: 50.0, // Set height as desired

                  child: TextField(
                    controller: idNo,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 50.0,
            ),
            ElevatedButton(
              onPressed: () async {
                tscNo = tscNoController.text;
                BuildContext currentContext = context;
                String response =  await activate(tscNoController.text, idNo.text);
                if(response=="200"){
                  // prefs = await SharedPreferences.getInstance();
                  // prefs.setString("tsc_no", tscNo.text);
                  // prefs.setString("id_no", idNo.text);
                  print(response);
                  Navigator.of(currentContext).push(MaterialPageRoute(builder: (context) {
                    return ConfirmOTP();
                  }));
                }else {
                  // if (kDebugMode) {
                  //   print(response.toString());
                  //   print("tsc_no: ${tscNo.text}");
                  //   print("id_no: ${idNo.text}");
                  // }
                }
              },
              child: const Text(
                "activate",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
            ),
            const SizedBox(height: 70,),
            TextButton(onPressed: (){
              navigator(const Login(), context, true);
            }, child: const Text("login"))
          ],
        ),
      ),
    );
  }
}
