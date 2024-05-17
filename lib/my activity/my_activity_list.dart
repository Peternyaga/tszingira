import 'package:flutter/cupertino.dart';
import 'package:tsc_miti/my%20activity/my%20activity%20item.dart';

import 'my_activity_modal.dart';

class MyActivityListBuilder extends StatelessWidget {
  final List<MyActivityItemModal> list;
  const MyActivityListBuilder({super.key, required this.list});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index){
          return MyActivityItem(item: list[index]);
        }
    );
  }
}
