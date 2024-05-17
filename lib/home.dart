import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tsc_miti/constants.dart';
import 'package:tsc_miti/exercise_modal.dart';
import 'package:tsc_miti/exercises_list.dart';
import 'package:tsc_miti/functions.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => HomeState();
}

class HomeState extends State<Home> {
   bool shouldRebuild = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        //backgroundColor: Colors.green[200],
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            //const Icon(Icons.home),
            const SizedBox(
              width: 70,
            ),
            const Center(
              child: Text("Ongoing exercises"),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.centerRight,
                child: PopupMenuButton(
                  icon: const Icon(Icons.account_circle),
                  onSelected: (String value) async {
                    bool refresh = await handleMenuSelection(value, context);
                    if(refresh){
                      setState(() {
                        shouldRebuild = true;
                      });
                    }
                  },
                  itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                    const PopupMenuItem<String>(
                      value: 'profile',
                      child: Row(
                       mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(Icons.account_circle_outlined),
                          Text("  my profile"),
                        ],
                      ),
                    ),
                    const PopupMenuItem<String>(
                      value: 'activity',
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(CupertinoIcons.graph_square),
                          Text("  my activity"),
                        ],
                      ),
                    ),
                    const PopupMenuItem<String>(
                      value: 'exercises',
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(Icons.access_time_outlined),
                          Text("  my exercises"),
                        ],
                      ),
                    ),
                    const PopupMenuItem<String>(
                      value: 'register',
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(Icons.add),
                          Text("  Register an exercise"),
                        ],
                      ),
                    ),
                    // Add more PopupMenuItems as needed
                  ],

                ),
              ),
            )
          ],
        ),
      ),
      body: FutureBuilder<String>(
        future: getStringRequest({}, fetchExercisesURL), // Your fetchExercises function returning a Future<String>
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While data is being fetched, show a loading indicator
            return const Center(child: CircularProgressIndicator());
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
            int status = 0;
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
                 status = item['status'];


                 exerciseItems.add(ExerciseModal(exerciseId: exerciseId, exerciseName: exerciseName, location: location, start: start, targetSeedlings: target, plantedSeedlings: planted, participants: participants, status: status));
               }

            }catch(e){
              print(e.toString());
              mylist=[1,2,3,4];
            }
            return ExercisesList(list: exerciseItems, myContext: 1,);
            // If data is fetched successfully, display it
          }
        },
      ),
    );
  }
}
