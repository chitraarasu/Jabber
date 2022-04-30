import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomImageView extends StatelessWidget {
  final image;
  CustomImageView(this.image);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepOrange,
        onPressed: () {
          Get.back();
        },
        child: const Icon(
          Icons.send_rounded,
          color: Colors.white,
        ),
      ),
      body: Stack(
        children: [
          InteractiveViewer(
            child: Image.file(
              File(image.path),
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                icon: const Icon(
                  Icons.close_rounded,
                  size: 35,
                  color: Colors.deepOrange,
                ),
                onPressed: () {
                  Get.back();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
