import 'package:flutter/material.dart';
import 'package:testproject/constants.dart';
import 'package:testproject/functions.dart';
import 'package:testproject/my%20exercises/my_exercises.dart';

class RegisterExerciseBody extends StatefulWidget {
  const RegisterExerciseBody({super.key});

  @override
  State<RegisterExerciseBody> createState() => _RegisterExerciseBodyState();
}

class _RegisterExerciseBodyState extends State<RegisterExerciseBody> {
  TextEditingController tscNoEditor = TextEditingController();
  TextEditingController exerciseNameEditor = TextEditingController();
  TextEditingController exerciseLocationEditor = TextEditingController();
  TextEditingController targetSeedlingsEditor = TextEditingController();
  TextEditingController phoneNoEditor = TextEditingController();
  FocusNode focusNode = FocusNode();

  void navigator(dynamic destination){
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (context) => destination));
  }
  @override
  Widget build(BuildContext context) {
    tscNoEditor.text = tscNo;
    focusNode.requestFocus();
    return SingleChildScrollView(
      child: Center(
          child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  "TSC Number",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
              ),
              SizedBox(
                width: 200.0, // Set width as desired
                height: 50.0, // Set height as desired
                child: Container(
                  color: Colors.white60,
                  child: Focus(
                    child: TextField(
                      controller: tscNoEditor,
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                      hintText: 'Enter your text here...',
                      border: OutlineInputBorder(),
                      )
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  "Phone number",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
              ),
              SizedBox(
                width: 200.0, // Set width as desired
                child: Container(
                  color: Colors.white60,
                  child: Focus(
                    child: TextField(
                        controller: phoneNoEditor,
                        focusNode: focusNode,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          hintText: 'Enter your phone no. here...',
                          border: OutlineInputBorder(),
                        )
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  "exercise name",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
              ),
              SizedBox(
                width: 300.0, // Set width as desired
                child: Container(
                  color: Colors.white60,
                  child: Focus(
                    child: TextField(
                      controller: exerciseNameEditor,
                      textAlign: TextAlign.center,
                      maxLines: null, // Allows the TextField to resize vertically
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline, // Displays 'return' key
                      decoration: const InputDecoration(
                      hintText: 'Enter the exercise name here...',
                      border: OutlineInputBorder(),
                      )
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  "location",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
              ),
              SizedBox(
                width: 300.0, // Set width as desired
                child: Container(
                  color: Colors.white60,
                  child: Focus(
                    child: TextField(
                        controller: exerciseLocationEditor,
                        textAlign: TextAlign.center,
                        maxLines: null, // Allows the TextField to resize vertically
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.newline, // Displays 'return' key
                        decoration: const InputDecoration(
                          hintText: 'Enter exercise location here...',
                          border: OutlineInputBorder(),
                        )
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  "Target seedlings",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
              ),
              SizedBox(
                width: 150.0, // Set width as desired
                child: Container(
                  color: Colors.white60,
                  child: Focus(
                    child: TextField(
                        controller: targetSeedlingsEditor,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: 'Enter target seedlings here...',
                          border: OutlineInputBorder(),
                        )
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(40.0),
                child: ElevatedButton(onPressed: ()
                    async {
                      String tscNumber = tscNoEditor.text;
                      String phone = phoneNoEditor.text;
                      String exerciseName = exerciseNameEditor.text;
                      String location = exerciseLocationEditor.text;
                      int? target = int.tryParse(targetSeedlingsEditor.text);
      
                      if(tscNumber.isNotEmpty && phone.isNotEmpty && exerciseName.isNotEmpty && location.isNotEmpty && !(target == null)){
                        Map data = {
                          'exercise':exerciseName,
                          'initiator':tscNumber,
                          'initiator contact':phone,
                          'location':location,
                          'target seedlings':target
                        };
                        String response = await postStringRequest(data, registerExercise);
                        if(response == "1"){
                         navigator(const MyExercises());
                         toast("success");
                        }
                      }else{
                        toast("some fields are empty");
                      }
      
                    }, child: const Text(
                  "submit",
                  style: TextStyle(
                    fontWeight: FontWeight.bold
                  ),
                )),
              )
            ],
          )
      ),
    );
  }
}
