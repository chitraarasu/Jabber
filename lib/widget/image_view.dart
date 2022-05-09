import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

class CustomImageView extends StatefulWidget {
  final image;
  CustomImageView(this.image);

  @override
  State<CustomImageView> createState() => _CustomImageViewState();
}

class _CustomImageViewState extends State<CustomImageView> {
  var isLoding = false;

  UploadTask? uploadTask;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepOrange,
        onPressed: () async {
          if (widget.image != null) {
            var url;
            final ref = FirebaseStorage.instance
                .ref()
                .child(
                    'user_data/${FirebaseAuth.instance.currentUser!.uid}/images')
                .child("${DateTime.now()}_${widget.image.name}");
            setState(() {
              uploadTask = ref.putFile(
                File(widget.image.path),
              );
            });
            final snapshot = await uploadTask!.whenComplete(() {});
            url = await snapshot.ref.getDownloadURL();
            setState(() {
              uploadTask = null;
            });
          }
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
              File(widget.image.path),
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.close_rounded,
                      size: 35,
                      color: Colors.deepOrange,
                    ),
                    onPressed: () {
                      Get.back();
                    },
                  ),
                ],
              ),
            ),
          ),
          StreamBuilder<TaskSnapshot>(
            stream: uploadTask?.snapshotEvents,
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.hasData) {
                final data = snapshot.data!;
                double progress = data!.bytesTransferred / data.totalBytes;
                return Align(
                  alignment: Alignment.center,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularProgressIndicator(
                        value: progress,
                        color: Colors.blue,
                      ),
                      Text(
                        '${(100 * progress).roundToDouble()}%',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return Container();
              }
            },
          )
        ],
      ),
    );
  }
}
