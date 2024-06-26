import 'dart:convert';
import 'package:intl/intl.dart';


import 'package:flutter/material.dart';
import 'package:tsc_miti/constants.dart';
import 'package:tsc_miti/dashboard/bar%20graph/bar_graph.dart';
import 'package:tsc_miti/dashboard/dashboard.dart';
import 'package:tsc_miti/dashboard/dashboard_modal.dart';
import 'package:tsc_miti/dashboard/leaderboard_item_modal.dart';
import 'package:tsc_miti/dashboard/leaderboard_list_builder.dart';
import 'package:tsc_miti/functions.dart';

class DashboardBody extends StatefulWidget {
   DashboardData data;

   DashboardBody({super.key, required this.data});

  @override
  State<DashboardBody> createState() => _DashboardBodyState();
}

class _DashboardBodyState extends State<DashboardBody> {
  bool refreshDashboard = false;
  String breakDownTitle = "Regional Breakdown";
  String summary = "regional";
  bool summaryLoading = false;
  List<LeaderboardItemModal> performanceList = [];
  String financialYear = "FY";

  Future<void> summaryFilter(String filter)async {
    setState(() {
      summaryLoading = true;
    });
    switch (filter){
      case "Secretariat":
        String data = await getStringRequest({}, secretariatUpdateURL);
        try {
          List list = jsonDecode(data);
          performanceList.clear();
          for(int i = 0; i<list.length; i++){
            performanceList.add(LeaderboardItemModal(name: list[i]["station name"], treeNumber: list[i]["treecount"]));
          }
          setState(() {
            summaryLoading = false;
            summary = "change";
          });
        } catch (e) {
          toast("an error occured. Try again");
        }
        break;
      case "Teachers":
        String data = await getStringRequest({}, teachersUpdateURL);
        try {
          List list = jsonDecode(data);
          performanceList.clear();
          for(int i = 0; i<list.length; i++){
            performanceList.add(LeaderboardItemModal(name: list[i]["station name"], treeNumber: list[i]["treecount"]));
          }
          setState(() {
            summaryLoading = false;
            summary = "change";
          });
        } catch (e) {
          toast("an error occured. Try again");
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            //mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: SizedBox(
                  height: 120,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Total trees planted:",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          Text(
                            "${widget.data.totalTrees}",
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 100,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Your trees:",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          Text(
                            "${widget.data.myTrees}",
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
              flex: 2,
              child: Card(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: Text(
                              breakDownTitle,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                          ),
                          Expanded(
                            child: PopupMenuButton(
                             child: Row(
                                 mainAxisAlignment:MainAxisAlignment.center,
                                 children: [Text(financialYear), const Icon(Icons.arrow_drop_down)],),
                              onSelected: (String value) async {
                               if(value == "0"){
                                 setState(() {
                                   summaryLoading = true;
                                   financialYear = "FY";
                                 });
                                 widget.data = await fetchDashboardData(
                                     "2022-06-01 00:00:00",
                                     today);
                                 setState(() {
                                   summaryLoading = false;
                                   Dashboard.refresh = true;
                                 });
                               }else {
                                 int year = int.parse(value);
                                 setState(() {
                                   summaryLoading = true;
                                   financialYear = "${year - 1}/$year";
                                 });
                                 widget.data = await fetchDashboardData(
                                     "${year - 1}-06-01 00:00:00",
                                     "$value-05-30 23:59:59");
                                 setState(() {
                                   summaryLoading = false;
                                   Dashboard.refresh = true;
                                 });
                               }
                              },
                              itemBuilder: (BuildContext context) {
                                List<PopupMenuItem<String>> list = [];
                                list.add(const PopupMenuItem<String>(
                                  value: '0',
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      //Icon(Icons.account_circle_outlined),
                                      Text("All"),
                                    ],
                                  ),));
                                int currentYear = int.parse(DateFormat('mm').format(DateTime.now()))>3? int.parse(DateFormat('yyyy').format(DateTime.now()))+1:int.parse(DateFormat('yyyy').format(DateTime.now()));
                                for(int i = currentYear; i>2022; i--){
                                  list.add(PopupMenuItem<String>(
                                      value: '$i',
                                      child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                      //Icon(Icons.account_circle_outlined),
                                      Text(" ${i-1}/$i"),
                                ],
                                ),));
                                }
                                return list;
                              }
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: PopupMenuButton(
                              icon: const Icon(Icons.filter_alt),
                              onSelected: (String value) async {
                                switch (value){
                                  case "Secretariat":
                                    summaryFilter(value);
                                    break;
                                  case "Teachers":
                                    summaryFilter(value);
                                    break;
                                  case "Regions":
                                    setState(() {
                                      summary = "regional";
                                    });
                                }
                                setState(() {
                                  breakDownTitle = "$value Breakdown";
                                });
                              },
                              itemBuilder: (BuildContext context) =>
                                  <PopupMenuEntry<String>>[
                                const PopupMenuItem<String>(
                                  value: 'Secretariat',
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      //Icon(Icons.account_circle_outlined),
                                      Text(" Secretariat"),
                                    ],
                                  ),
                                ),
                                const PopupMenuItem<String>(
                                  value: 'Teachers',
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      //Icon(Icons.account_circle_outlined),
                                      Text("  Teachers"),
                                    ],
                                  ),
                                ),
                                    const PopupMenuItem<String>(
                                      value: 'Regions',
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          //Icon(Icons.),
                                          Text("  Regions"),
                                        ],
                                      ),
                                    ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    Expanded(
                      child: Builder(
                        builder: (context) {
                          if (summaryLoading){
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          switch (summary){
                            case "change":
                              return LeaderboardListBuilder(list: performanceList);
                            default:
                              return BarGraph(
                                regionalSummary: widget.data.regionalSummary,
                              );
                          }

                        }
                      ),
                    )
                  ],
                ),
              )),
          Expanded(
            child: Card(
              child: Column(
                children: [
                  const Center(
                    child: Text(
                      "Leaderboard",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                  Expanded(
                    child: Builder(
                      builder: (BuildContext context) {
                        return Scrollbar(
                            child: LeaderboardListBuilder(
                                list: widget.data.leaderboardList));
                      },
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
