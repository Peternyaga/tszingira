import 'package:flutter/material.dart';
import 'package:testproject/my%20activity/my_activity_modal.dart';

class MyActivityItem extends StatefulWidget {
  final MyActivityItemModal item;
  const MyActivityItem({super.key, required this.item});

  @override
  State<MyActivityItem> createState() => _MyActivityItemState();
}

class _MyActivityItemState extends State<MyActivityItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 1.0),
        child: Container(
            color: Colors.green[50],
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
                          "Trees Planted:  ",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            // color: Colors.purple[700]
                          ),
                        ),
                        Text(
                          widget.item.treesPlanted,
                          overflow: TextOverflow.visible,
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              color: Colors.green[500]),
                        ),
                      ],
                    ),
                  )
                ]))));
  }
}
