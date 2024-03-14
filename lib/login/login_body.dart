import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testproject/account%20activation.dart';
import 'package:testproject/dashboard/dashboard.dart';
import 'package:testproject/dashboard/dashboard_modal.dart';
import 'package:testproject/dashboard/leaderboard_item_modal.dart';
import '../constants.dart';
import '../functions.dart';


class LoginBody extends StatefulWidget {
  const LoginBody({super.key});

  @override
  State<LoginBody> createState() => _LoginBodyState();
}

class _LoginBodyState extends State<LoginBody> {
  FocusNode tscNoFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  TextEditingController tscNoEditor = TextEditingController();
  TextEditingController passwordEditor = TextEditingController();
  bool isLoading = false;
  void callNavigator(dynamic destination, bool pop){
    navigator(destination, context, pop);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Card(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              //crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Column(
                  children: [
                    SizedBox(
                      width: 300.0, // Set width as desired
                      height: 50.0, // Set height as desired
                      child: Container(
                        color: Colors.white60,
                        child: Focus(
                          child: TextField(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                              ), // Creates rounded borders
                              labelText: 'TSC NO', // Optional label text
                            ),
                            focusNode: tscNoFocusNode,
                            controller: tscNoEditor,
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 70,),
                    SizedBox(
                      width: 300.0, // Set width as desired
                      height: 50.0, // Set height as desired
                      child: Container(
                        color: Colors.white60,
                        child: Focus(
                          child: TextField(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(), // Creates rounded borders
                              labelText: 'PASSWORD', // Optional label text
                              //hintText: 'Enter text here', // Optional hint text
                            ),
                            obscureText: true,
                            focusNode: passwordFocusNode,
                            controller: passwordEditor,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 50.0,
                ),
                ElevatedButton(
                  onPressed:
                  isLoading ? null
                      :() async {
                    if(tscNoEditor.text.isNotEmpty && passwordEditor.text.isNotEmpty) {
                      setState(() {
                        isLoading = true;
                      });
                      Map data = {
                        'tsc_no': tscNoEditor.text,
                        'password': passwordEditor.text
                      };
                      dynamic response = await postStringRequest(data, loginURL);
                      setState(() {
                        isLoading = false;
                      });
                      int responseCode;
                      if (response == 500){
                        responseCode = 103;
                      }else{
                        toast(response);
                      responseCode = jsonDecode(response)['code'];
                      }
                      print(response);
                      if(responseCode == 0){
                        SharedPreferences myprefs = await SharedPreferences.getInstance();
                        tscNo = tscNoEditor.text;
                        await myprefs.setString("tsc no", tscNo);
                        await myprefs.setString("password", passwordEditor.text);
                        toast("success ${myprefs.getString("password")}");
                        List<String> name = jsonDecode(response)['0']['name'].split(" ");
                        firstName = name[0];
                        totalTrees = jsonDecode(response)['total trees'];
                        myTrees = jsonDecode(response)['my trees'];

                        List topPlanters = jsonDecode(response)['leaderboard'];
                        leaderboardList.clear();
                        for (int i = 0; i<topPlanters.length; i++){
                          Map planter = topPlanters[i];
                          print(leaderboardList.length);
                          leaderboardList.add(LeaderboardItemModal(name: planter['name'], treeNumber: planter['count']));
                        }

                        List regionalSummary = jsonDecode(response)['regional performance'];
                        regionalSummaryList.clear();
                        for(int i = 0; i<regionalSummary.length; i++){
                          Map region = regionalSummary[i];
                          regionalSummaryList.add(region['count']);
                        }
                        print(regionalSummaryList);
                        //callNavigator(Dashboard(), true);
                        callNavigator(Dashboard(data: DashboardData(name: firstName, totalTrees: totalTrees, myTrees: myTrees, regionalSummary: regionalSummaryList, leaderboardList: leaderboardList),), true);
                      }else if(responseCode==102) {
                        toast("Incorrect tsc_no or password");
                      }else{
                        toast("An error occurred. Please try again");
                      }
                    }else{
                      toast("All fields are required");
                    }
                  },
                  child:
                  isLoading
                      ? const CircularProgressIndicator()
                      : const Text(
                    "login",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                ),
                const SizedBox(height: 70,),
                ElevatedButton(onPressed: (){
                  navigator(const Activation(), context, true);
                }, child: const Text("Activate Account"))
              ],
            ),
          ),
        ),
      ),
    );

  }
  }

