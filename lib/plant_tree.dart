import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:testproject/constants.dart';
import 'package:testproject/image_picker.dart';
import 'package:http/http.dart' as http;

class PlantTree extends StatelessWidget {
  final String exercise, tscNo;
  final int exerciseId;
  PlantTree({super.key, required this.exercise, required this.tscNo, required this.exerciseId});
  /*
  * The static variables are set in the MyImagePicker class when an image is selected
  * */
  static FocusNode myFocusNode = FocusNode();
  static bool imageIsSelected = false;
  static XFile? image;
  TextEditingController text = TextEditingController();
  MyImagePicker imagePicker = const MyImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(
        backgroundColor: Colors.green[200],
        centerTitle: true,
        title: const Text(
          "Plant a tree",
        ),
      ),
      body: Column(
       // mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(12.0, 20.0, 12.0, 0.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Exercise:  ",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Expanded(
                    child: Text(
                     exercise,
                      //overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.green[500]
                      ),
                    ),
                  ),
                ]
            ),

          ),
          const SizedBox(
            height: 30,
          ),
          const MyImagePicker(),
          Padding(
            padding: EdgeInsets.fromLTRB(12.0, 20.0, 12.0, 0.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Plant Name:  ",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      focusNode: myFocusNode,
                      textAlign: TextAlign.center,
                      textCapitalization: TextCapitalization.sentences,
                      controller: text,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                          color: Colors.green[500]
                      ),
                    ),
                  ),
                ]
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                alignment: Alignment.bottomRight,
                child: FloatingActionButton(
                    onPressed: (){
                      if(imageIsSelected && text.text!=null && text.text.isNotEmpty){
                        uploadImage();
                        print(image!.path);
                      }else{
                        toast("Please select an image and enter the name of the tree");
                      }
                    },
                  child: const Text(
                    "Upload"
                  ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
Future<void> uploadImage()async {
var uri = Uri.parse(imageUpload);
var request = http.MultipartRequest('POST', uri);
var multipartFile = await http.MultipartFile.fromPath('image', image!.path);
request.files.add(multipartFile);
request.fields['exercise'] = exercise;

try {
  dynamic response = await request.send();
  if (response.statusCode == 200) {
    var responseBody = await response.stream.bytesToString();
    var decodedResponse = jsonDecode(responseBody);
    response = await uploadRecord(decodedResponse['path']);
    if (response=="1"){
      text.clear();
     toast("record uploaded successfully");
    }else {
      toast("A problem occurred, please try again");
    }
  } else {
    toast("A problem occurred, please try again");
    if (kDebugMode) {
      print('Failed to upload image - ${response.statusCode}');
    }
  }
} catch (error) {
  // Handle exceptions
  if (kDebugMode) {
    print('Error uploading image: $error');
  }
}
}

Future<String> uploadRecord(String imagePath) async {
    Map<String, dynamic> data = {
      'exercise': exerciseId,
      'tsc_no': tscNo,
      'tree_name': text.text,
      'photo': imagePath
    };

    try{
      var response = await http.post(
        Uri.parse(plantTree),
        headers:<String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(data)
      );
      return response.body;
    }catch(e){
      return e.toString();
    }
}

void toast(String message){
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: Colors.black,
    textColor: Colors.white,
  );
}
}
