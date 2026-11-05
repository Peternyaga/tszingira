import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tsc_miti/exercise_modal.dart';
import 'package:tsc_miti/login/Login.dart';
import 'package:tsc_miti/my%20activity/my_activity.dart';
import 'package:tsc_miti/my%20exercises/my_exercises.dart';
import 'package:tsc_miti/register%20exercise/register_exercise.dart';

import 'constants.dart';
import 'dashboard/dashboard_modal.dart';
import 'dashboard/leaderboard_item_modal.dart';

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
}else if(value == "logout") {
    showDialog(
        context: context,
        builder:(context){
          return AlertDialog(
            content: const Text("You are about to logout. \n Continue?"),
            actions: [
              TextButton(onPressed: () async {
                clearPrefs();
                Navigator.pop(context);
                navigator(const Login(), context, true);
              }, child: const Text("Ok")),
              TextButton(onPressed: (){
                Navigator.pop(context);
              }, child: const Text("Cancel"))
            ],
          );
        });
    return false;
  }else{
    return false;
  }
}

Future<void> clearPrefs () async {
  SharedPreferences myPrefs = await SharedPreferences.getInstance();
  myPrefs.clear();
}

Future<dynamic> postStringRequest(Map data, String url) async {
data['api_key'] = const String.fromEnvironment('TSC_API_KEY');
  try{
    var response = await http.post(
        Uri.parse(url),
        headers:<String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'api_key': const String.fromEnvironment('TSC_API_KEY')
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

Future<String> getStringRequest(Map<String, String> query, String url) async {
  query['api_key'] = const String.fromEnvironment('TSC_API_KEY');
  final uri = Uri.parse(url).replace(queryParameters: query);
  var response = await http.get(uri);
  return response.body;
}

Future<String> fetchMyExercises(String query) async {
  final Map<String,String> data = {
    'query':query
  };
  final uri = Uri.parse(fetchMyExercisesURL).replace(queryParameters: data);
  var response = await http.get(uri);
  return response.body;
}

Future<int> paricipate(ExerciseModal item) async {
  final Map<String, String> params = {
    'exercise':item.exerciseName,
    'tsc_no':tscNo,
    'api_key':const String.fromEnvironment('TSC_API_KEY')
  };
  final uri = Uri.parse(participateURL).replace(queryParameters: params);
  var response = await http.get(uri);
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


Future<DashboardData> fetchDashboardData(String start, end) async {
  Map<String, String> query = {
    'query': tscNo,
    'start_date': start,
    'end_date': end,
  };
  String response = await getStringRequest(query, dashboardUpdateURL);
  final data = jsonDecode(response);
  String name = firstName;
  int totalTreesPlanted = data['total trees'];
  int myTrees = data['my trees'];
  List regionalPerformance = data['regional performance'];
  List<int> regionalSummary = [];
  for (int i = 0; i<regionalPerformance.length; i++){
    Map region = regionalPerformance[i];
    regionalSummary.add(region['count']);
  }
  List topPlanters = data['leaderboard'];
  List<LeaderboardItemModal> leaderboard = [];
  for(int i = 0; i<topPlanters.length; i++){
    Map planter = topPlanters[i];
    leaderboard.add(LeaderboardItemModal(name: planter['name'], treeNumber: planter['count']));
  }
  return DashboardData(name: name, totalTrees: totalTreesPlanted, myTrees: myTrees, regionalSummary: regionalSummary, leaderboardList: leaderboard);
}