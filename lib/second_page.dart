import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SecondPage extends StatefulWidget {
  static const routeName = '/second-page';
  
    const SecondPage({super.key});

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {

  final ImagePicker _imagePicker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          appBar: AppBar(
            // TRY THIS: Try changing the color here to a specific color (to
            // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
            // change color while the other colors stay the same.
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            // Here we take the value from the MyHomePage object that was created by
            // the App.build method, and use it to set our appbar title.
            title: const Text('Second Page'),
          ),
          resizeToAvoidBottomInset: true,
          body: Container(
            padding: const EdgeInsets.all(16.0),
            width: double.infinity,
            height: double.infinity,
            child: Center(
              child: ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(topRight: Radius.circular(18.0), bottomRight: Radius.circular(18.0)),
                  )),
                ),
                onPressed: () async {
                  await _takePhoto();
                },
                child: const Icon(Icons.camera_alt),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Foto aufnehmen
  Future<void> _takePhoto() async {

        final XFile? _imageFile = await _imagePicker.pickImage(source: ImageSource.camera, maxHeight: 1024, maxWidth: 1024, imageQuality: 80);

        if (_imageFile != null) {
          final File _asFile = File(_imageFile.path);
          final Uint8List _imageBytes = await _asFile.readAsBytes();

          final String _asBase64 = base64.encode(_imageBytes);
          await _asFile.delete();


          // do other stuff
        }
  }  
}
