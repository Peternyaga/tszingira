import 'package:flutter/material.dart';
import 'package:testproject/account%20activation.dart';
import 'package:testproject/home.dart';
import 'package:testproject/register.dart';

void main() {
  runApp(const MaterialApp(
    home: Home()
  ),
  );
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});


  @override
  Widget build(BuildContext context) {

    Future.delayed(const Duration(seconds: 5), () {
      // Navigate to the new screen after 2 seconds
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Activation()),
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

