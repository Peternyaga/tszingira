import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tsc_miti/plant_tree.dart';
import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class MyImagePicker extends StatefulWidget {
  const MyImagePicker({super.key});

  @override
  State<MyImagePicker> createState() => _MyImagePickerState();
}

class _MyImagePickerState extends State<MyImagePicker> {
  final ImagePicker picker = ImagePicker();
  static XFile? image;
  Future<void> getImage() async {
    final XFile? selectedImage = await picker.pickImage(source: ImageSource.gallery);
    print(selectedImage);
    if (selectedImage != null) {
      PlantTree.myFocusNode.requestFocus();
      PlantTree.imageIsSelected = true;
      PlantTree.image = selectedImage;
      setState(() {
        image = selectedImage;
      });
    }
  }

  Future<File?> compressImage(File file) async {
    const int maxSizeInBytes = 1 * 1024 * 1024; // 1MB

    // Compress the image to ensure it is less than 1MB
    List<int> compressedBytes = await FlutterImageCompress.compressWithFile(
      file.absolute.path,
      minWidth: 1000,
      minHeight: 1000,
      quality: 90,
    ) ?? [];

    File compressedFile = File('${file.parent.path}/compressed');
    await compressedFile.writeAsBytes(compressedBytes);

    // Check if the compressed image is within the size limit
    while (compressedBytes.length > maxSizeInBytes) {
      int quality = (90 * maxSizeInBytes / compressedBytes.length).floor();
      quality = quality > 0 ? quality : 1;
      compressedBytes = await FlutterImageCompress.compressWithFile(
        file.absolute.path,
        minWidth: 1000,
        minHeight: 1000,
        quality: quality,
      ) ?? [];
      compressedFile = File('${file.parent.path}/compressed');
      await compressedFile.writeAsBytes(compressedBytes);
    }

    return compressedFile;
  }
  // void clearData() {
  //   setState(() {
  //     image = null;
  //   });
  // }
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
