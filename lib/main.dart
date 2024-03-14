import 'package:flutter/material.dart';
import 'package:testproject/login/Login.dart';
import 'package:testproject/splashscreen.dart';

void main() {
  runApp( MaterialApp(
    theme: ThemeData.light().copyWith(
      cardTheme: CardTheme(color: Colors.tealAccent[50]),
        appBarTheme: AppBarTheme(color: Colors.blue[900]
        ),
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: Colors.green,
          onPrimary: Colors.white, // Adjusted for better contrast
          secondary: Colors.green,
          onSecondary: Colors.white, // Adjusted for better contrast
          error: Colors.amber,
          onError: Colors.black, // Adjusted for better contrast
          background: Colors.teal,
          onBackground: Colors.green, // Adjusted for better contrast
          surface: Colors.white, // Use a predefined color or define a custom one
          onSurface: Colors.black, // Adjusted for better contrast
        )
    ),
    home: const HomeScreen(),
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
      //backgroundColor: Colors.green[100],
      appBar: AppBar(
        //backgroundColor: Colors.green[100],
      ),
      body:  const Splashscreen(),
    );
  }
}

