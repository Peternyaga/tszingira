
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:testproject/exercise_modal.dart';
import 'package:testproject/my%20activity/my_activity.dart';
import 'package:testproject/my%20exercises/my_exercises.dart';
import 'package:testproject/register%20exercise/register_exercise.dart';

import 'constants.dart';

void toast(String message){
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: Colors.black,
    textColor: Colors.white,
  );
}

Future<bool> handleMenuSelection(String value, BuildContext context) async {
  if(value=="register"){
    return await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegisterExercise()),
    );
  }else if(value == "exercises"){
    return await Navigator.push(context, MaterialPageRoute(builder: (context) => const MyExercises())
    );

  }else if(value == "activity"){
return await Navigator.push(context, MaterialPageRoute(builder: (context) => const MyActivity())
);
}else{
    return false;
  }
}

Future<dynamic> postStringRequest(Map data, String url) async {

  try{
    var response = await http.post(
        Uri.parse(url),
        headers:<String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body:jsonEncode(data)
    );
    if (response.statusCode == 200){
    return response.body;
    }else{
      return 500;
    }
  }catch(e){
    return e.toString();
  }
}

Future<String> getStringRequest(String query, String url) async {
  final Map<String,String> data = {
    'query':query
  };
  final uri = Uri.parse(url).replace(queryParameters: data);
  var response = await http.get(uri);
  print(response.statusCode);
  print(response.body);
  return response.body;
}

Future<String> fetchMyExercises(String query) async {
  final Map<String,String> data = {
    'query':query
  };
  final uri = Uri.parse(fetchMyExercisesURL).replace(queryParameters: data);
  var response = await http.get(uri);
  print(response.statusCode);
  print(response.body);
  return response.body;
}

Future<int> paricipate(ExerciseModal item) async {
  final Map<String, String> params = {
    'exercise':item.exerciseName,
    'tsc_no':tscNo
  };
  final uri = Uri.parse(participateURL).replace(queryParameters: params);
  var response = await http.get(uri);
  print(response.body);
  return response.statusCode;
}

void navigator(dynamic destination, BuildContext context, bool pop) {
  if(pop){
  Navigator.pop(context);
  }
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => destination),
  );
}
