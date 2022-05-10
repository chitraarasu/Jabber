import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

class CustomImageView extends StatefulWidget {
  final image;
  final channelId;
  CustomImageView(this.image, this.channelId);

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
            final user = FirebaseAuth.instance.currentUser!;
            final userData = await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .get();
            FirebaseFirestore.instance
                .collection('messages')
                .doc(widget.channelId)
                .collection("channelChat")
                .add({
              'message': url,
              'messageType': "image",
              'createdTime': Timestamp.now(),
              'senderId': user.uid,
              'senderName': userData['username'],
            });
            FirebaseFirestore.instance
                .collection('messages')
                .doc(widget.channelId)
                .update({
              'recentMessage': url,
              'time': Timestamp.now(),
            });
            FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .collection("userChannels")
                .doc(widget.channelId)
                .update({
              'recentMessage': url,
              'time': Timestamp.now(),
            });
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
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Color(0xC9000000),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.close_rounded,
                          size: 35,
                          color: Colors.white,
                        ),
                      ),
                    ),
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
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Color(0xC9000000),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CircularProgressIndicator(
                            value: progress,
                            color: Colors.white,
                          ),
                          Text(
                            '${(100 * progress).roundToDouble()}%',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 7,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
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
