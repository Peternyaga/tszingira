import 'package:flutter/material.dart';
import 'package:testproject/dashboard/bar%20graph/bar_graph.dart';
import 'package:testproject/dashboard/dashboard_modal.dart';
import 'package:testproject/dashboard/leaderboard_list_builder.dart';

class DashboardBody extends StatefulWidget {
  final DashboardData data;
  const DashboardBody({super.key, required this.data});

  @override
  State<DashboardBody> createState() => _DashboardBodyState();
}

class _DashboardBodyState extends State<DashboardBody> {
  bool refreshDashboard = false;
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
                    const Center(
                      child: Text(
                        "Regional summary",
                        style: TextStyle(fontWeight: FontWeight.bold,
                        fontSize: 16),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                        height: 300,
                        child: BarGraph(
                          regionalSummary: widget.data.regionalSummary,
                        ))
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
                      style: TextStyle(fontWeight: FontWeight.bold,
                      fontSize: 16),
                    ),
                  ),
                  Expanded(
                    child: Builder(
                      builder: (BuildContext context) {
                        return Scrollbar(child: LeaderboardListBuilder(list: widget.data.leaderboardList));
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
