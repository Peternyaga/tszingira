import 'package:flutter/material.dart';
//import 'package:fluttertoast/fluttertoast.dart';
import 'package:testproject/constants.dart';
import 'package:testproject/exercise_modal.dart';
import 'package:http/http.dart' as http;
import 'package:testproject/plant_tree.dart';
//import 'package:toast/toast.dart';
//import 'package:fluttertoast/fluttertoast.dart';

class ExerciseItem extends StatelessWidget {
  final ExerciseModal item;
  const ExerciseItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 1.0),
      child:Container(
        color: Colors.green[50],
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(5.0),
                    child: Text(
                        item.exerciseName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
              ),
              Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "location:  ",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                           // color: Colors.purple[700]
                        ),
                      ),
                      Text(item.location,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            color: Colors.green[500]
                        ),
                      ),
                  ],
                  ),
                ),
              Padding(
                padding: EdgeInsets.all(5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Target seedlings:  ",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          // color: Colors.purple[700]
                        ),
                      ),
                      Text(
                          item.targetSeedlings.toString(),
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            color: Colors.green[500]
                        ),
                      ),
                ]
                ),
              ),
              Padding(
                padding: EdgeInsets.all(5.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "planted seedlings:  ",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          // color: Colors.purple[700]
                        ),
                      ),
                      Text(
                        item.plantedSeedlings.toString(),
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            color: Colors.green[500]
                        ),
                      ),
                    ]
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      print("${item.exerciseName} clicked");
                      int status = await paricipate();
                      if (status==200){
                       Navigator.push(context, MaterialPageRoute(builder: (context)=>PlantTree(exercise: item.exerciseName, tscNo: '$tscNo',exerciseId: item.exerciseId)));
                      }
                    },
                    child: const Text(
                      "participate"
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<int> paricipate() async {
    final Map<String, String> params = {
      'exercise':item.exerciseName,
      'tsc_no':tscNo
    };
    final uri = Uri.parse(participateURL).replace(queryParameters: params);
    var response = await http.get(uri);
    print(response.body);
    return response.statusCode;
  }

}
