import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:testproject/constants.dart';
import 'package:testproject/exercise_modal.dart';
import 'package:testproject/exercises_list.dart';

class Home extends StatelessWidget {
  const Home({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        backgroundColor: Colors.green[200],
        //centerTitle: true,
        title: const Row(
          children: [
            Icon(Icons.home),
            SizedBox(
              width: 70,
            ),
            Center(
              child: Text("Ongoing exercises"),
            ),
          ],
        ),
      ),
      body: FutureBuilder<String>(
        future: fetchExercises(""), // Your fetchExercises function returning a Future<String>
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While data is being fetched, show a loading indicator
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // If an error occurs during fetching, display an error message
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<dynamic> mylist;
            List<ExerciseModal> exerciseItems=[];
            String exerciseName="";
            String location="";
            dynamic target="";
            dynamic planted = "";
            String start = "";
            int participants = 0;
            int exerciseId;
            try{

               mylist = jsonDecode(snapshot.data.toString());

               for(int i = 0; i<mylist.length; i++){
                 Map item = mylist[i];

                 exerciseId = item['id'];
                 exerciseName= item['exercise name'];
                 location = item['location'];
                 target = item['target seedlings'];
                 planted = item['planted seedlings'];
                 start = item['start'];
                 participants = item['participants'];

                 exerciseItems.add(ExerciseModal(exerciseId: exerciseId, exerciseName: exerciseName, location: location, start: start, targetSeedlings: target, plantedSeedlings: planted, participants: participants));
               }

            }catch(e){
              print(e.toString());
              mylist=[1,2,3,4];
            }
            return ExercisesList(list: exerciseItems);
            // If data is fetched successfully, display it
          }
        },
      ),
    );
  }

  Future<String> fetchExercises(String query) async {
    final Map<String,String> data = {
      'query':query
    };
    final uri = Uri.parse(fetchExercisesURL).replace(queryParameters: data);
    var response = await http.get(uri);
    print(response.statusCode);
    print(response.body);
    return response.body;
  }
}
