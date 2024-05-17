import 'package:flutter/material.dart';
import 'package:tsc_miti/register%20exercise/register_exercise_body.dart';

class  RegisterExercise extends StatelessWidget {
  const RegisterExercise({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
      centerTitle: true,
      backgroundColor: Colors.green[100],
      title: const Text("Register a planting exercise"),
    ),
      body:  WillPopScope (
          onWillPop: () async{
            Navigator.pop(context,false);
        return false;
        },
      child: const RegisterExerciseBody()),
    );
  }
}
