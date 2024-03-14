import 'package:flutter/material.dart';
import 'package:testproject/dashboard/leaderboard_item.dart';
import 'package:testproject/dashboard/leaderboard_item_modal.dart';

class LeaderboardListBuilder extends StatelessWidget {
  final List<LeaderboardItemModal> list;
  const LeaderboardListBuilder({super.key, required this.list});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: list.length,
        itemBuilder: (context,index){
        return LeaderboardItem(item: list[index], position: index+1);
        });
  }
}
