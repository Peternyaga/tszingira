import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tsc_miti/dashboard/dashboard.dart';
import 'package:tsc_miti/login/Login.dart';
import 'package:tsc_miti/splashscreen.dart';

import 'constants.dart';

void main() {
  runApp( MaterialApp(
    theme: ThemeData.light().copyWith(
      cardTheme: CardTheme(color: Colors.tealAccent[50]),
        appBarTheme: AppBarTheme(color: Colors.blue[900],
        ),
        // textTheme: const TextTheme(
        //   headline6: TextStyle(
        //     color: Colors.teal, // Set your desired title color here
        //   ),
        // ),
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
    void navigate(Widget dest){
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => dest));
    }

    Future.delayed(const Duration(seconds: 2), () async {
      SharedPreferences myPrefs =  await SharedPreferences.getInstance();
      if(myPrefs.containsKey('tsc no') && myPrefs.containsKey('first name')){
        tscNo = myPrefs.getString('tsc no')!;
        firstName = myPrefs.getString('first name')!;
        Dashboard.refresh = true;
        navigate(Dashboard());
      }else{
        navigate(const Login());
      }
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

