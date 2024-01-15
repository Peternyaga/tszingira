import 'package:flutter/material.dart';
import 'package:testproject/exercise_item.dart';

class ExercisesList extends StatelessWidget {
   final List list;
   final int myContext;
   const ExercisesList({super.key, required this.list, required this.myContext});


  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        return ExerciseItem(item:list[index], myContext: myContext,);
      },
    );
  }
}
