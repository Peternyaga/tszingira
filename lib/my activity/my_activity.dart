import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:testproject/constants.dart';
import 'package:testproject/functions.dart';
import 'package:testproject/my%20activity/my_activity_list.dart';
import 'package:testproject/my%20activity/my_activity_modal.dart';

class MyActivity extends StatelessWidget {
  const MyActivity({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Activity"),
        centerTitle: true,
        backgroundColor: Colors.green[200],
      ),
      body: FutureBuilder<String>(
        future: getStringRequest(tscNo, myActivityURL),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
          // While data is being fetched, show a loading indicator
          return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
          // If an error occurs during fetching, display an error message
          return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<MyActivityItemModal> list = [];
            try {
              List myList = jsonDecode(snapshot.data.toString())['exercises'];
              print(myList[0]);
              for(int i = 0; i < myList.length; i ++){
                //list.add(value)
                list.add(MyActivityItemModal(myList[i]['exercise name'], myList[i]['count'].toString()));
              }
              return MyActivityListBuilder(list: list);

            } catch (e) {
              print("error ++++++++++++++++++++++");
              print("error: ${e.toString()}");
              return const Center(child: Text("No activity to show.\n Please plant a tree."),);
            }

          }
        },
      ),
    );
  }
}
