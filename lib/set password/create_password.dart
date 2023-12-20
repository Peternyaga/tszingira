import 'package:flutter/material.dart';
import 'package:testproject/set%20password/set_password_body.dart';

class SetPassword extends StatelessWidget {
  const SetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[100],
      appBar: AppBar(
        backgroundColor: Colors.green[100],
        centerTitle: true,
        title: const Text("Set password"),
      ),
      body:  const SetPasswordBody(),
    );
  }
}
