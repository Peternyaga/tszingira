import 'package:flutter/material.dart';

import 'my_exercises_body.dart';

class MyExercises extends StatelessWidget {
  const MyExercises({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("my exercises"),
        backgroundColor: Colors.green[200],
      ),
      body: WillPopScope(
          onWillPop: () async {
            Navigator.pop(context, true);
            return false;
          },
          child: const MyExercisesBody()),
    );
  }
}
