import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:testproject/dashboard/dashboard_body.dart';
import 'package:testproject/dashboard/dashboard_modal.dart';
import 'package:testproject/dashboard/leaderboard_item_modal.dart';
import 'package:testproject/functions.dart';
import 'package:testproject/home.dart';
import 'package:testproject/plant_tree.dart';

import '../constants.dart';

class Dashboard extends StatefulWidget {
   DashboardData? data;
   Dashboard({super.key,  this.data});
  static bool refresh = false;

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int item=0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: (){
              toast("whats up $firstName?");
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Column(
                  children: [
                    const Text("Hi",
                      style: TextStyle(
                           // fontWeight: FontWeight.bold
                      ),),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(firstName,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold
                          )),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      body: Builder(
        builder: (context) {
          if(Dashboard.refresh) {
            Dashboard.refresh = false;
            print("*****************");
            return FutureBuilder(future: fetchDashboardData(),
              builder: (BuildContext context,
                  AsyncSnapshot<DashboardData> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // While data is being fetched, show a loading indicator
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  toast("${snapshot.error}");
                  print("%%%%%%%%%%%%%%%%%%%%%");
                  // If an error occurs during fetching, display an error message
                  return DashboardBody(data: widget.data!);
                } else {
                  print("@@@@@@@@@@@@@@@@@@@@@@");
                  return DashboardBody(data: snapshot.data!);
                }
              },
            );
          }else{
            return DashboardBody(data: widget.data!);
          }
        }
      ),
      bottomNavigationBar: BottomNavigationBar(
      currentIndex: item,
      onTap: (int index){

        switch (index){
          case 1:
            //Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (context)=> PlantTree(exercise: null, tscNo: tscNo, exerciseId: null))).then((value) async {
              if (value == "refresh"){
                DashboardData dData = await fetchDashboardData();
                setState(() {
                  widget.data = dData;
                });
              }
            });
            //navigator(PlantTree(exercise: null, tscNo: tscNo, exerciseId: null), context, false);
            break;
          case 2:
            navigator(const Home(), context, false);
            break;
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.emoji_nature),
          label: 'plant a tree',
        ),
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.graph_square),
          label: 'Exercises',
        ),
      ],
    ),
      // floatingActionButton: FloatingActionButton(onPressed: () {  },
      // shape: const CircleBorder(),
      //   child: const Icon(Icons.add),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.,
    );
  }
  Future<DashboardData> fetchDashboardData() async {
    String response = await getStringRequest(tscNo, dashboardUpdateURL);
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
}
