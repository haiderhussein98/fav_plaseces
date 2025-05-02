import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Imageinput extends StatefulWidget {
  const Imageinput({super.key, required this.onaddimage});
  final void Function(File image) onaddimage;

  @override
  State<Imageinput> createState() {
    return _Imageinput();
  }
}

class _Imageinput extends State<Imageinput> {
  File? selectedimage;

  void _takepicture() async {
    final imagepicker = ImagePicker();
    final pickedimage =
        await imagepicker.pickImage(source: ImageSource.camera, maxWidth: 600);

    if (pickedimage == null) {
      return;
    }
    setState(() {
      selectedimage = File(pickedimage.path);
    });

    widget.onaddimage(selectedimage!);
  }

  @override
  Widget build(BuildContext context) {
    Widget content = selectedimage == null
        ? TextButton.icon(
            onPressed: _takepicture,
            label: Text('Take picture'),
            icon: Icon(
              Icons.camera,
            ),
          )
        : GestureDetector(
            onTap: _takepicture,
            child: Image.file(
              selectedimage!,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          );

    return Container(
      margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
      alignment: Alignment.center,
      height: 250,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
        ),
      ),
      child: content,
    );
  }
}
