import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerFile extends StatefulWidget {
  const ImagePickerFile(this.pickedImageFn, {super.key});
  final void Function(File image) pickedImageFn;

  @override
  State<ImagePickerFile> createState() => _ImagePickerFileState();
}

class _ImagePickerFileState extends State<ImagePickerFile> {
  File? image;

  void _pickImage() async {
    final XFile? pickedImage = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
    );
    if (pickedImage == null) {
      return;
    }
    setState(() {
      image = File(pickedImage.path);
    });
    widget.pickedImageFn(image!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: Theme.of(context).primaryColor,
          backgroundImage: image != null ? FileImage(image!) : null,
        ),
        TextButton.icon(
            onPressed: _pickImage,
            icon: const Icon(Icons.image),
            label: const Text('Add an image'))
      ],
    );
  }
}
