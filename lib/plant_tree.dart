import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:native_exif/native_exif.dart';
import 'package:tsc_miti/constants.dart';
import 'package:tsc_miti/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

import 'functions.dart';

class PlantTree extends StatefulWidget {
  final String? exercise;
  final String tscNo;
  final int? exerciseId;

  PlantTree(
      {super.key,
      required this.exercise,
      required this.tscNo,
      required this.exerciseId});

  bool refreshDashboard = true;

  /*
  * The static variables are set in the MyImagePicker class when an image is selected
  * */
  static FocusNode myFocusNode = FocusNode();
  static bool imageIsSelected = false;
  static XFile? image;

  @override
  State<PlantTree> createState() => _PlantTreeState();
}

class _PlantTreeState extends State<PlantTree> {
  TextEditingController treeName = TextEditingController();
  TextEditingController noOfTrees = TextEditingController();
  MyImagePicker imagePicker = const MyImagePicker();
  int sitePresenceGroupValue = 0;
  int treeNameKnowledgeGroupValue = 1;
  bool isUploading = false;
  bool recordUploaded = false;
  DateTime plantingDate = DateTime.now();
  final ImagePicker picker = ImagePicker();
  static XFile? image;

  Future<void> selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
        context: context, firstDate: DateTime(2023), lastDate: DateTime.now());
    if (pickedDate != null) {
      plantingDate =
          DateTime(pickedDate.year, pickedDate.month, pickedDate.day);
    } else {
      toast("please select a date");
      //selectDate();
    }
  }

  Future<void> getImage() async {
    final XFile? selectedImage = await picker.pickImage(
        source: sitePresenceGroupValue == 1
            ? ImageSource.camera
            : ImageSource.gallery);
    if (selectedImage != null) {
      plantingDate =
          DateTime(plantingDate.year, plantingDate.month, plantingDate.day);
      final exif = await Exif.fromPath(selectedImage.path);
      DateTime? imageDate = await exif.getOriginalDate();
      print("selected date: $plantingDate");
      print("image date: $imageDate");
      if (imageDate == null) {
        toast("Select an image captured from your device");
        return;
      }
      //toast("coordinates: $coordinates");
      imageDate = DateTime(imageDate.year, imageDate.month, imageDate.day);
      if (imageDate.isAtSameMomentAs(plantingDate)) {
        PlantTree.myFocusNode.requestFocus();
        PlantTree.imageIsSelected = true;
        PlantTree.image = selectedImage;
        setState(() {
          image = selectedImage;
        });
      } else {
        toast(
            "The image you selected was not captured on the planting date selected");
      }
    }
  }

  Future<void> getLocation() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      bool serviceEnabled;
      LocationPermission permission;

      // Test if location services are enabled.
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Location services are not enabled don't continue
        // accessing the position and request users of the
        // App to enable the location services.
        toast('Location services are disabled.');
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // Permissions are denied, next time you could try
          // requesting permissions again (this is also where
          // Android's shouldShowRequestPermissionRationale
          // returned true. According to Android guidelines
          // your App should show an explanatory UI now.
          toast('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        // Permissions are denied forever, handle appropriately.
        toast(
            'Location permissions are permanently denied, we cannot request permissions.');
      }

      // When we reach here, permissions are granted and we can
      // continue accessing the position of the device.
      toast(Geolocator.getCurrentPosition().toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.green[50],
      appBar: AppBar(
        //backgroundColor: Colors.green[200],
        centerTitle: true,
        title: const Text(
          "Plant a tree",
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Column(
                  children: [
                    SizedBox(
                      child: Builder(builder: (BuildContext context) {
                        if (widget.exercise != null) {
                          return Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    12.0, 20.0, 12.0, 0.0),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Center(
                                          child: Text(
                                            widget.exercise!,
                                            style: const TextStyle(
                                              //backgroundColor: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ]),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                            ],
                          );
                        } else {
                          return const Padding(
                            padding: EdgeInsets.all(8.0),
                          );
                        }
                      }),
                    ),
                    const SizedBox(
                      child: Card(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("Are you at the planting site?"),
                          )),
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Expanded(
                        child: RadioListTile(
                            title: const Text("Yes"),
                            value: 1,
                            groupValue: sitePresenceGroupValue,
                            onChanged: (value) {
                              getLocation();
                              setState(() {
                                image = null;
                                sitePresenceGroupValue = value!;
                              });
                            }),
                      ),
                      Expanded(
                        child: RadioListTile(
                            title: const Text("No"),
                            value: 2,
                            groupValue: sitePresenceGroupValue,
                            onChanged: (value) {
                              selectDate();
                              setState(() {
                                sitePresenceGroupValue = value!;
                              });
                            }),
                      ),
                    ]),
                    const SizedBox(
                      height: 30,
                    ),
                    SizedBox(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(children: [
                          Center(
                            child: image == null
                                ? const Text('No image selected.')
                                : Image.file(
                              File(image!.path),
                              height: 270,
                              width: 300,
                              fit: BoxFit.cover,
                            ),
                          ),
                          ElevatedButton(
                              onPressed: getImage,
                              child: const Text("Select image"))
                        ]),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    const SizedBox(
                      child: Card(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("Do you know the name of this tree?"),
                          )),
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: RadioListTile(
                                title: const Text("Yes"),
                                value: 1,
                                groupValue: treeNameKnowledgeGroupValue,
                                onChanged: (value) {
                                  setState(() {
                                    treeNameKnowledgeGroupValue = value!;
                                  });
                                }),
                          ),
                          Expanded(
                            child: RadioListTile(
                                title: const Text("No"),
                                value: 2,
                                groupValue: treeNameKnowledgeGroupValue,
                                onChanged: (value) {
                                  setState(() {
                                    treeNameKnowledgeGroupValue = value!;
                                  });
                                }),
                          ),
                        ]),
                    Builder(builder: (context) {
                      if (treeNameKnowledgeGroupValue != 2) {
                        return Padding(
                          padding:
                          const EdgeInsets.fromLTRB(12.0, 20.0, 12.0, 0.0),
                          child: TextField(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              // Creates rounded borders
                              labelText:
                              'Enter tree name', // Optional label text
                            ),
                            focusNode: PlantTree.myFocusNode,
                            textAlign: TextAlign.center,
                            textCapitalization: TextCapitalization.sentences,
                            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]'))],
                            controller: treeName,
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.normal,
                                color: Colors.green[500]),
                          ),
                        );
                      } else {
                        return const SizedBox();
                      }
                    }),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12.0, 20.0, 12.0, 0.0),
                      child: TextField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          // Creates rounded borders
                          labelText:
                          'How many trees did you plant?', // Optional label text
                        ),
                        //focusNode: PlantTree.myFocusNode,
                        textAlign: TextAlign.center,
                        keyboardType: const TextInputType.numberWithOptions(signed: false, decimal: false),
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        controller: noOfTrees,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                            color: Colors.green[500]),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: FloatingActionButton(
                          onPressed: () {
                            if (image != null) {
                              if (treeNameKnowledgeGroupValue != 2 &&
                                  treeName.text.isEmpty) {
                                toast("Enter the name of the tree.");
                              } else {
                                setState(() {
                                  isUploading = true;
                                });
                                uploadImage();
                              }
                            } else {
                              toast("Please select an image.");
                            }
                          },
                          child: Builder(builder: (context) {
                            if (isUploading) {
                              return const CircularProgressIndicator(
                                color: Colors.white,
                              );
                            } else {
                              return const Text("Upload");
                            }
                          }),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> uploadImage() async {
    Map<String, String> data = {
      'api_key': 'REMOVED_ROTATE_CREDENTIAL'
    };
    var uri = Uri.parse(imageUpload).replace(queryParameters: data);

    Uint8List? compressedImage = await compressImage(File(PlantTree.image!.path));
     var request = http.MultipartRequest('POST', uri);
    if (compressedImage != null) {
      //Create a MultipartFile from the compressed image
      var multipartFile = http.MultipartFile.fromBytes(
        'image',
        compressedImage,filename: 'image'
      );
      request.files.add(multipartFile);
    }
     // var multipartFile = await http.MultipartFile.fromPath('image', PlantTree.image!.path);
     // request.files.add(multipartFile);
    if (widget.exercise != null) {
      request.fields['exercise'] = widget.exercise!;
    } else {
      request.fields['exercise'] = "";
    }
    try {
      dynamic response = await request.send();

      if (response.statusCode == 200) {
        var responseBody = await response.stream.bytesToString();
        var decodedResponse = jsonDecode(responseBody);
        response = await uploadRecord(decodedResponse['path']);
        setState(() {
          isUploading = false;
        });
        if (response == "1") {
          showSuccessDialog();
          setState(() {
            recordUploaded = true;
            isUploading = false;
            image = null;
            treeName.clear();
            //Navigator.of(context).pop("refresh");
          });
          toast("record uploaded successfully");
        } else {
          toast("A problem occurred, please try again");
        }
      } else {
        setState(() {
          isUploading = false;
        });
        toast("A problem occurred, please try again");
        if (kDebugMode) {
          print('Failed to upload image - ${response.statusCode}');
        }
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error uploading image: $error');
      }
      toast("Error uploading image. Please try again");
      setState(() {
        isUploading = false;
      });
    }
  }


  Future<Uint8List?> compressImage(File file) async {
    const int maxSizeInBytes = 1 * 1024 * 1024; // 1MB

    // Initial compression
    Uint8List? compressedBytes = await FlutterImageCompress.compressWithFile(
      file.absolute.path,
      minWidth: 1000,
      minHeight: 1000,
      quality: 90,
    );

    if (compressedBytes == null) {
      return null;
    }

    // Check if the compressed image is within the size limit
    while (compressedBytes!.length > maxSizeInBytes) {
      int quality = (90 * maxSizeInBytes / compressedBytes.length).floor();
      quality = quality > 0 ? quality : 1;
      compressedBytes = await FlutterImageCompress.compressWithFile(
        file.absolute.path,
        minWidth: 1000,
        minHeight: 1000,
        quality: quality,
      );

      if (compressedBytes == null) {
        return null;
      }
    }

    return compressedBytes;
  }

  void showSuccessDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: const Text(
                "record was uploaded successfully. Do you want to upload another record?"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('yes')),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop("refresh");
                  },
                  child: const Text('No'))
            ],
          );
        });
  }

  void backToDash() {
    Navigator.of(context).pop("refresh");
  }

  Future<String> uploadRecord(String imagePath) async {
    Map<String, dynamic> data = {
      'exercise': widget.exerciseId,
      'tsc_no': widget.tscNo,
      'tree_name': treeName.text,
      'no_of_trees': noOfTrees.text,
      'photo': imagePath,
      'api_key': 'REMOVED_ROTATE_CREDENTIAL'
    };

    try {
      var response = await http.post(Uri.parse(plantTree),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(data));
      toast(response.body);
      return response.body;
    } catch (e) {
      return e.toString();
    }
  }

}