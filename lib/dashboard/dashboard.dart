import 'package:intl/intl.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tsc_miti/dashboard/dashboard_body.dart';
import 'package:tsc_miti/dashboard/dashboard_modal.dart';
import 'package:tsc_miti/functions.dart';
import 'package:tsc_miti/home.dart';
import 'package:tsc_miti/plant_tree.dart';

import '../constants.dart';

class Dashboard extends StatefulWidget {
   DashboardData? data;
   Dashboard({super.key,  this.data});
   static bool refresh = false;
   @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard>{
  int item=0;
  String startDate = "2023-03-00 00:00:00";
  String endDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

  void getPrefs()async{
    SharedPreferences myPrefs =  await SharedPreferences.getInstance();
    tscNo = myPrefs.getString('tsc no')!;
    firstName = myPrefs.getString('first name')!;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Padding(
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
            Expanded(
              child: Container(
                alignment: Alignment.centerRight,
                child: PopupMenuButton(
                  icon: const Icon(Icons.account_circle),
                  onSelected: (String value) async {
                    if (value == "logout"){

                    }
                    bool refresh = await handleMenuSelection(value, context);
                    if(refresh){
                      setState(() {
                        //shouldRebuild = true;
                      });
                    }
                  },
                  itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                    const PopupMenuItem<String>(
                      value: 'activity',
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(CupertinoIcons.graph_square),
                          Text("  my activity"),
                        ],
                      ),
                    ),
                    const PopupMenuItem<String>(
                      value: 'exercises',
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(Icons.access_time_outlined),
                          Text("  my exercises"),
                        ],
                      ),
                    ),
                    const PopupMenuItem<String>(
                      value: 'register',
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(Icons.add),
                          Text("  Register an exercise"),
                        ],
                      ),
                    ),
                    const PopupMenuItem<String>(
                      value: 'logout',
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(Icons.logout),
                          Text("  Logout"),
                        ],
                      ),
                    ),
                  ],

                ),
              ),
            )
          ],
        ),
      ),
      body: RefreshIndicator(

        onRefresh: () { setState(() {
          Dashboard.refresh=true;
        });
          return Future(() => null);
          },
        child: Builder(
          builder: (context) {
            if(Dashboard.refresh) {
              Dashboard.refresh = false;
              return FutureBuilder(future: fetchDashboardData(startDate, today),
                builder: (BuildContext context,
                    AsyncSnapshot<DashboardData> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // While data is being fetched, show a loading indicator
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child:  Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        mainAxisAlignment:  MainAxisAlignment.center,
                        children: [
                          const Expanded(child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "Oops! We couldn't establish a connection with the server. Check your internet connection and refresh",
                              style: TextStyle(color: Colors.pink),),
                          )),
                          IconButton(onPressed: (){setState(() {
                            Dashboard.refresh = true;
                          });}, icon: const Icon(Icons.refresh))
                        ],
                      ),
                    ),);
                    //return DashboardBody(data: widget.data!);
                  } else {
                    widget.data = snapshot.data;
                    return DashboardBody(data: snapshot.data!);
                  }
                },
              );
            }else{
              if (widget.data == null){
                setState(() {
                  Dashboard.refresh = true;
                });
                return Center(child:  Row(
                  mainAxisAlignment:  MainAxisAlignment.center,
                  children: [
                    const Text("An error occured",style: TextStyle(color: Colors.pink),),
                    IconButton(onPressed: (){setState(() {
                      Dashboard.refresh = true;
                    });}, icon: const Icon(Icons.refresh))
                  ],
                ),);
              }
              return DashboardBody(data: widget.data!);
            }
          }
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
      currentIndex: item,
      onTap: (int index){

        switch (index){
          case 1:
            //Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (context)=> PlantTree(exercise: null, tscNo: tscNo, exerciseId: null))).then((value) async {
              if (value == "refresh"){
                DashboardData dData = await fetchDashboardData(startDate, today);
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
    );
  }

}
