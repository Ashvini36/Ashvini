import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class FullScreenImage extends StatelessWidget {
  final String? imageUrl;
  final File? imageFile;

  const FullScreenImage({super.key, this.imageUrl, this.imageFile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.black,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Container(
          color: Colors.black,
          child: PhotoView(
            imageProvider: imageFile == null ? NetworkImage(imageUrl!) : Image.file(imageFile!).image,
          ),
        ));
  }
}
