import 'package:flutter/material.dart';
import 'package:testproject/dashboard/leaderboard_item_modal.dart';

class LeaderboardItem extends StatelessWidget {
  final int position;
  final LeaderboardItemModal item;
  const LeaderboardItem({super.key, required this.item, required this.position});

  @override
  Widget build(BuildContext context) {
    String name = item.name;
    int treeCount = item.treeNumber;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text("$position. $name"),
          const SizedBox(width: 30,),
          Text("$treeCount")
        ],
      ),
    );
  }
}
