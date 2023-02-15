import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ScreenMain extends StatefulWidget {
  const ScreenMain({super.key});

  @override
  State<ScreenMain> createState() => _ScreenMainState();
}

class _ScreenMainState extends State<ScreenMain> {
  File? image;
  List imagelist = [];

  Future getImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image == null) return;
    final imageTemp = File(image.path);
    imagelist.add(imageTemp);
    // GallerySaver.saveImage(image.path,
    // toDcim: true, albumName: 'cameraAppgallerry');

    setState(() {
      this.image = imageTemp;

      imagelist;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Camera'),
      ),
      body: ListView(
        children: [
          IconButton(
            onPressed: () async {
              PermissionStatus cameraStatus = await Permission.camera.request();
              if (cameraStatus == PermissionStatus.granted) {
                getImage();
              } else if (cameraStatus == PermissionStatus.denied) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('The Permission is recommended.'),
                  ),
                );
              } else if (cameraStatus == PermissionStatus.permanentlyDenied) {
                openAppSettings();
              }
            },
            icon: const Icon(CupertinoIcons.camera_fill),
          ),
          Container(
              width: MediaQuery.of(context).size.width * 8,
              height: MediaQuery.of(context).size.height * .8,
              decoration: BoxDecoration(border: Border.all(width: 2)),
              child: imagelist.isEmpty
                  ? const Center(
                      child: Text('No image'),
                    )
                  : GridView.count(
                      crossAxisCount: 2,
                      children: List.generate(imagelist.length, (index) {
                        var img = imagelist[index];
                        return Image.file(img);
                      }),
                    ))
        ],
      ),
    );
  }
}
