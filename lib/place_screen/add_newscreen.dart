import 'dart:io';
import 'package:favirote_plaseces/widget/loactioninput.dart';
import 'package:favirote_plaseces/main.dart';
import 'package:favirote_plaseces/widget/imageinput.dart';
import 'package:flutter/material.dart';
import 'package:favirote_plaseces/moudel/place.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:favirote_plaseces/Providers/myplasece.dart';

class AddNewscreen extends ConsumerStatefulWidget {
  const AddNewscreen({super.key});

  @override
  ConsumerState<AddNewscreen> createState() {
    return _AddNewscreenState();
  }
}

class _AddNewscreenState extends ConsumerState<AddNewscreen> {
  final controller = TextEditingController();
  bool iserror = false;
  File? onpickimage;
  PlaceLocation? mylocation;

  void _savePlace() {
    final entiername = controller.text;

    if (entiername.trim().isEmpty ||
        onpickimage == null ||
        mylocation == null) {
      iserror = true;
      return;
    }

    ref.read(myplace.notifier).addpalce(
          entiername,
          onpickimage!,
          mylocation!,
        );

    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('add your place'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(9.0),
              child: TextField(
                style: Theme.of(context).textTheme.titleMedium,
                controller: controller,
                decoration: InputDecoration(
                    label: Text('name of place'),
                    error: iserror
                        ? Text(
                            'this filed can not be empty',
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium!
                                .copyWith(color: colorScheme.error),
                          )
                        : null),
                maxLength: 50,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Imageinput(
              onaddimage: (image) {
                onpickimage = image;
              },
            ),
            SizedBox(
              height: 16,
            ),
            Loactioninput(
              mylocation: (location) {
                mylocation = location;
              },
            ),
            SizedBox(
              height: 16,
            ),
            TextButton(
              onPressed: () {
                _savePlace();
                setState(() {
                  iserror = controller.text.isEmpty;
                });
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.add,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text('add'),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
