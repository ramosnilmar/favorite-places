import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageInput extends StatefulWidget {
  const ImageInput({super.key, required this.onPickImage});

  final void Function(File pickedImage) onPickImage;

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? _storeImage;

  void _takePicture() async {
    final imagePiker = ImagePicker();
    final pikedImage =
        await imagePiker.pickImage(source: ImageSource.camera, maxWidth: 600);

    if (pikedImage == null) {
      return;
    }

    setState(() {
      _storeImage = File(pikedImage.path);
    });

    widget.onPickImage(_storeImage!);
  }

  @override
  Widget build(BuildContext context) {
    Widget content = TextButton.icon(
      onPressed: _takePicture,
      icon: const Icon(Icons.camera),
      label: const Text('Take Picture'),
    );

    if (_storeImage != null) {
      content = GestureDetector(
        onTap: _takePicture,
        child: Image.file(
          _storeImage!,
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
        ),
      );
    }

    return Column(
      children: <Widget>[
        Container(
          width: double.infinity,
          height: 250,
          decoration:
              BoxDecoration(border: Border.all(width: 1, color: Colors.grey)),
          alignment: Alignment.center,
          child: content,
        ),
      ],
    );
  }
}
