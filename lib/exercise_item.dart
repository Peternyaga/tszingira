import 'package:flutter/material.dart';
import 'package:testproject/constants.dart';
import 'package:testproject/exercise_modal.dart';
import 'package:testproject/plant_tree.dart';
import 'functions.dart';

class ExerciseItem extends StatefulWidget {
  final ExerciseModal item;
  final int myContext;
  const ExerciseItem({super.key, required this.item, required this.myContext});

  @override
  State<ExerciseItem> createState() => _ExerciseItemState();
}

class _ExerciseItemState extends State<ExerciseItem> {
  @override
  Widget build(BuildContext context) {

    void navigator(dynamic destination){
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => destination));
    }
    String status;
    if(widget.item.status == 0){
      status = "Pending";
    }else if(widget.item.status == 1){
      status = "Open";
    }else if(widget.item.status == 2){
      status = "Closed";
    }else{
      status = "Null";
    }

    return  Padding(
      padding: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 1.0),
      child:Container(
        color: Colors.teal[50],
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                    child: Text(
                        widget.item.exerciseName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "status:  ",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        // color: Colors.purple[700]
                      ),
                    ),
                    Text(status,
                      overflow: TextOverflow.visible,
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          //color: Colors.green[500]
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                  padding: const EdgeInsets.all(5.0),
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
                      Expanded(
                        child: Text(widget.item.location,
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              //overflow: TextOverflow.ellipsis
                              //color: Colors.green[500]
                          ),
                        ),
                      ),
                  ],
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(5.0),
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
                          widget.item.targetSeedlings.toString(),
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            //color: Colors.green[500]
                        ),
                      ),
                ]
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
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
                        widget.item.plantedSeedlings.toString(),
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            //color: Colors.green[500]
                        ),
                      ),
                    ]
                ),
              ),
              Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Builder(
                    builder: (BuildContext context) {
                      if (widget.myContext == 1) {
                        return ElevatedButton(
                          onPressed: () async {
                            print("${widget.item.exerciseName} clicked");
                            int status = await paricipate(widget.item);
                            if (status == 200) {
                              navigator(PlantTree(
                                  exercise: widget.item.exerciseName,
                                  tscNo: tscNo,
                                  exerciseId: widget.item.exerciseId));
                            }
                          },
                          child: const Text("participate"),
                        );
                      } else if(widget.myContext == 2){
                        if(widget.item.status== 0){
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(onPressed: () async {
                                Map data = {
                                  'exercise': widget.item.exerciseName,
                                  'initiator': tscNo,
                                  'start': DateTime.now().toString()
                                };
                                print("response: ${DateTime.now().toString()}");
                                String response = await postStringRequest(data, startExercise);
                                if(response == "1"){
                                  setState(() {
                                    widget.item.status++;
                                  });
                                }else{
                                  toast("an error occured. please try again");
                                }
                                print("response: $response");
                              }, child: const Text("start")),
                            ],
                          );
                        }else {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(onPressed: () async {
                                int status = await paricipate(widget.item);
                                if (status == 200) {
                                  navigator(PlantTree(
                                      exercise: widget.item.exerciseName,
                                      tscNo: tscNo,
                                      exerciseId: widget.item.exerciseId));
                                }
                              }, child: const Text("participate")),
                              ElevatedButton(onPressed: () {
                                Navigator.pop(context,true);
                              }, child: const Text("close")),
                            ],
                          );
                        }
                      }else {
                        return const Row();
                      }
                    },
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }
}
