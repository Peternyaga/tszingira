import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:tsc_miti/login/Login.dart';
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
  bool obscurePass = true;
  bool obscureConfirmPass = true;
  bool showPassObscureIcon = false;
  bool showConfirmObscureIcon = false;

  void navigator(dynamic destination) {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => destination),
    );
  }

  Future<String> setPassword(String password, String tscNo) async {
    Map<String, String> data = {'password': password, 'tsc_no': tscNo, "api_key": const String.fromEnvironment('TSC_API_KEY')};

    try {
      var response = await http.post(Uri.parse(setPasswordURL),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(data));
      setState(() {
        isLoading = false;
      });
      print(response.body);
      return response.body;
    } catch (e) {
      return e.toString();
    }
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
              ),
              SizedBox(
                width: 300.0, // Set width as desired
                height: 50.0, // Set height as desired
                child: Container(
                  color: Colors.white60,
                  child: TextField(
                    onChanged: (input){
                      if (input.isNotEmpty){
                        setState(() {
                          showPassObscureIcon = true;
                        });
                      }else{
                        setState(() {
                          showPassObscureIcon = false;
                        });
                      }
                    },
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      // Creates rounded borders
                      labelText: 'PASSWORD',
                      suffixIcon: IconButton(
                        color: Colors.green,
                        icon: Builder(
                          builder: (context) {
                            if (showPassObscureIcon){
                              return Icon(
                                obscurePass ? Icons.visibility : Icons
                                    .visibility_off,
                              );
                            }else{
                              return const SizedBox();
                            }

                          }
                        ), onPressed: () {
                        setState(() {
                          obscurePass = !obscurePass;
                        });
                      },
                      ),
                    ),
                    // Optional label text
                    obscureText: obscurePass,
                    focusNode: passwordFocusNode,
                    controller: password,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
             const SizedBox(height:  50,),
              SizedBox(
                width: 300.0, // Set width as desired
                height: 50.0, // Set height as desired
                child: Container(
                  color: Colors.white60,
                  child: TextField(
                    onChanged: (input){
                      if (input.isNotEmpty){
                        setState(() {
                          showConfirmObscureIcon = true;
                        });
                      }else{
                        setState(() {
                          showConfirmObscureIcon = false;
                        });
                      }
                    },
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(), // Creates rounded borders
                      labelText: 'CONFIRM PASSWORD',
                      suffixIcon: IconButton(
                        color: Colors.green,
                        icon: Builder(
                          builder: (context) {
                            if (showConfirmObscureIcon) {
                              return Icon(
                                obscureConfirmPass ? Icons.visibility : Icons
                                    .visibility_off,
                              );
                            }else{
                              return const SizedBox();
                            }
                          }
                        ), onPressed: () { setState(() {
                        obscureConfirmPass = !obscureConfirmPass;
                      }); },
                        //hintText: 'Enter text here', // Optional hint text
                      ),
                    ),// Optional label text
                    obscureText: obscureConfirmPass,
                    focusNode: confirmFocusNode,
                    controller: confirmPassword,
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 50.0,
          ),
          ElevatedButton(
            onPressed: isLoading
                ? null
                : () async {
              setState(() {
                isLoading = true;
              });
              if (password.text.isNotEmpty) {
                if (password.text == confirmPassword.text) {
                  String response = await setPassword(md5.convert(utf8.encode(password.text)).toString(), tscNo);
                  if (response == "1") {
                    toast("success");
                    navigator(const Login());
                  } else {
                    toast("An error occurred. Please try again");
                  }
                } else {
                  toast("Your passwords do not match!");
                  confirmFocusNode.requestFocus();
                  // confirmPassword.clear();
                  // setState(() {
                  //   showConfirmObscureIcon = false;
                  // });
                }
              } else {
                toast("password cannot be empty!");
              }

              setState(() {
                isLoading = false;
              });
            },
            child: isLoading
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
