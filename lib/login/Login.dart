import 'package:flutter/material.dart';
import 'package:testproject/login/login_body.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     // backgroundColor: Colors.green[100],
      appBar: AppBar(
       // backgroundColor: Colors.green[200],
        title: const Text(
          "Login",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
      ),
      body: const LoginBody(),
    );
  }
}
