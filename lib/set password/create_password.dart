import 'package:flutter/material.dart';
import 'package:tsc_miti/set%20password/set_password_body.dart';

class SetPassword extends StatelessWidget {
  const SetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Set password"),
      ),
      body:  const SetPasswordBody(),
    );
  }
}
