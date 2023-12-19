import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:testproject/plant_tree.dart';
import 'dart:io';

class MyImagePicker extends StatefulWidget {
  const MyImagePicker({super.key});

  @override
  State<MyImagePicker> createState() => _MyImagePickerState();
}

class _MyImagePickerState extends State<MyImagePicker> {
  final ImagePicker picker = ImagePicker();
  XFile? image;
  Future<void> getImage() async {
    final XFile? selectedImage = await picker.pickImage(source: ImageSource.gallery);
    if (selectedImage != null) {
      PlantTree.myFocusNode.requestFocus();
      PlantTree.imageIsSelected = true;
      PlantTree.image = selectedImage;
      setState(() {
        image = selectedImage;
      });
    }
  }
  void clearData() {
    setState(() {
      image = null;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
        child: const Text("Select image")
    )
    ]);
  }
}
