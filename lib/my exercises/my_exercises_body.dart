import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:testproject/constants.dart';
import '../exercise_modal.dart';
import '../exercises_list.dart';
import '../functions.dart';

class MyExercisesBody extends StatefulWidget {
  const MyExercisesBody({super.key});

  @override
  State<MyExercisesBody> createState() => _State();
}

class _State extends State<MyExercisesBody> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: fetchMyExercises(tscNo),
      // Your fetchExercises function returning a Future<String>
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
// While data is being fetched, show a loading indicator
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
// If an error occurs during fetching, display an error message
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if(!(snapshot.data.toString()=="0")){
          toast(snapshot.data.toString());
          List<dynamic> myList = [];
          List<ExerciseModal> exerciseItems = [];
          String exerciseName = "";
          String location = "";
          dynamic target = "";
          dynamic planted = "";
          String start = "";
          int participants = 0;
          int exerciseId;
          int status;
          try {
            myList = jsonDecode(snapshot.data.toString());

            for (int i = 0; i < myList.length; i++) {
              Map item = myList[i];

              exerciseId = item['id'];
              exerciseName = item['exercise name'];
              location = item['location'];
              target = item['target seedlings'];
              planted = item['planted seedlings'];
              if(item['start'] == null){
                start = "Not yet started";
              }else {
                start = item['start'];
              }
              participants = item['participants'];
              status = item['status'];

              exerciseItems.add(ExerciseModal(exerciseId: exerciseId,
                  exerciseName: exerciseName,
                  location: location,
                  start: start,
                  targetSeedlings: target,
                  plantedSeedlings: planted,
                  participants: participants, status: status));
            }
          } catch (e) {
            print("error: ${e.toString()}: ${myList[1]}");
            //myList = [1, 2, 3, 4];
          }
          return ExercisesList(list: exerciseItems, myContext: 2,);
        }else {
          return const Center(child: Text("You don't have any registered exercise"),);
        }
      },
    );
  }
}
