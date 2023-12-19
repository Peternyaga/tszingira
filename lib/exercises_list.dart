import 'package:flutter/material.dart';
import 'package:testproject/exercise_item.dart';
import 'package:testproject/exercise_modal.dart';

class ExercisesList extends StatelessWidget {
   List<ExerciseModal> list;
   ExercisesList({super.key, required this.list});


  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        return ExerciseItem(item:list[index]);
      },
    );
  }
}
