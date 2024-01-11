import 'package:flutter/material.dart';
import 'package:testproject/login/Login.dart';
import 'package:testproject/register.dart';

void main() {
  runApp(const MaterialApp(
    home: HomeScreen()
  ),
  );
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});


  @override
  Widget build(BuildContext context) {

    Future.delayed(const Duration(seconds: 2), () {
      // Navigate to the new screen after 2 seconds
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Login()),
      );
    });
    return Scaffold(
      backgroundColor: Colors.green[100],
      appBar: AppBar(
        backgroundColor: Colors.green[100],
      ),
      body:  const Register(),
    );
  }
}

