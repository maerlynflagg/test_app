import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as _imgpackage;
import './image_model.dart';

class SecondPage extends StatefulWidget {
  static const routeName = '/second-page';

  const SecondPage({super.key});

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  final ImagePicker _imagePicker = ImagePicker();

  final List<ImageModel> _images = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _childs = [];

    for (ImageModel i in _images) {
      _childs.add(Container(
        margin: const EdgeInsets.fromLTRB(5.0, 0, 5.0, 2.0),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(5.0)),
          child: Stack(
            children: <Widget>[
              Image.memory(base64.decode(i.thumbBase64), fit: BoxFit.cover, height: 200),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 30,
                  width: double.infinity,
                  color: Colors.black,
                  child: const Center(
                    child: Text('a pic', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 10)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ));
    }

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
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      await _takePhoto();
                    },
                    child: const Icon(Icons.camera_alt),
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _childs,
                  ),
                ),
              ],
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
      final File asFile = File(_imageFile.path);
      final Uint8List imageBytes = await asFile.readAsBytes();

      final String asBase64 = base64.encode(imageBytes);
      final _imgpackage.Image? image = _imgpackage.decodeImage(imageBytes);
      final _imgpackage.Image thumbnail = _imgpackage.copyResize(image!, height: 200);

      await asFile.delete();

      setState(() {
        _images.add(ImageModel(base64Image: asBase64, thumbBase64: base64.encode(_imgpackage.encodeJpg(thumbnail))));
      });
    }
  }
}
