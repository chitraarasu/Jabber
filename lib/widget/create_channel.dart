import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../controller/controller.dart';

enum buttonType {
  camera,
  gallery,
}

class CreateChannel extends StatelessWidget {
  const CreateChannel({
    Key? key,
    required FirebaseAuth auth,
    required this.getController,
  })  : _auth = auth,
        super(key: key);

  final FirebaseAuth _auth;
  final Controller getController;

  @override
  Widget build(BuildContext context) {
    TextEditingController channelNameController = TextEditingController();

    var maximumPeoples = 2.obs;

    // TextEditingController maxMemberController =
    //     TextEditingController(text: '${maximumPeoples.value}');
    //
    // var screenWidth = MediaQuery.of(context).size.width * 0.20;

    var isLoading = false.obs;
    PickedFile? imageFile;
    Future _takePicture(type) async {
      if (type == buttonType.camera) {
        imageFile = await ImagePicker.platform.pickImage(
          source: ImageSource.camera,
          imageQuality: 50,
        );
      } else {
        imageFile = await ImagePicker.platform.pickImage(
          source: ImageSource.gallery,
          imageQuality: 50,
        );
      }
      if (imageFile == null) {
        return;
      }
      Get.find<Controller>().setChannelProfileImage(
        File(imageFile!.path),
      );
    }

    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  children: [
                    GetBuilder<Controller>(
                      init: Controller(),
                      builder: (getController) => CircleAvatar(
                        backgroundColor: Colors.blueGrey,
                        radius: 67,
                        child: CircleAvatar(
                          radius: 65,
                          backgroundColor: Colors.white,
                          backgroundImage:
                              getController.channelProfileImage != null
                                  ? FileImage(
                                      getController.channelProfileImage,
                                    )
                                  : null,
                          child: getController.channelProfileImage != null
                              ? null
                              : const Icon(
                                  Icons.add_a_photo_rounded,
                                  size: 65,
                                  color: Colors.blueGrey,
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextButton.icon(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                const Color(0xFF006aff),
                              ),
                              padding: MaterialStateProperty.all(
                                const EdgeInsets.all(10),
                              ),
                            ),
                            onPressed: () {
                              _takePicture(buttonType.gallery);
                            },
                            label: const Text(
                              "Select image",
                              style: TextStyle(color: Colors.white),
                            ),
                            icon: const Icon(
                              Icons.upload_sharp,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(
                                color: Color(0xFF006aff),
                                width: 2.5,
                              ),
                              padding: const EdgeInsets.all(6.5),
                            ),
                            onPressed: () {
                              _takePicture(buttonType.camera);
                            },
                            label: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "Pick image",
                                style: TextStyle(
                                  color: Color(0xFF006aff),
                                ),
                              ),
                            ),
                            icon: const Icon(
                              Icons.camera_outlined,
                              color: Color(0xFF006aff),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                              border: Border.all(
                                width: 2,
                                color: Colors.blueGrey,
                              ),
                            ),
                            child: TextField(
                              textCapitalization: TextCapitalization.sentences,
                              maxLines: 1,
                              controller: channelNameController,
                              style: const TextStyle(color: Colors.blueGrey),
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.all(12.5),
                                hintText: 'Enter channel name',
                                border: InputBorder.none,
                                hintStyle: TextStyle(
                                  color: Colors.blueGrey,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: Colors.blueGrey,
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.insert_emoticon,
                              size: 40,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () async {
              try {
                if (!isLoading.value) {
                  if (channelNameController.text.trim().isNotEmpty) {
                    var randomDoc = FirebaseFirestore.instance
                        .collection("users")
                        .doc('${_auth.currentUser?.uid}')
                        .collection('userChannels')
                        .doc();
                    var randomId = randomDoc.id;
                    isLoading.value = true;
                    var url;
                    if (getController.channelProfileImage != null) {
                      final ref = FirebaseStorage.instance
                          .ref()
                          .child('channel_image')
                          .child("$randomId-${channelNameController.text}.jpg");
                      await ref.putFile(getController.channelProfileImage);
                      url = await ref.getDownloadURL();
                    }
                    var channelData = {
                      'channelId': randomId,
                      'channelName': channelNameController.text,
                      'channelOwnerId': _auth.currentUser?.uid,
                      'channelProfile': url,
                      "recentMessage": "",
                      "time": Timestamp.now(),
                    };
                    await FirebaseFirestore.instance
                        .collection("users")
                        .doc(_auth.currentUser?.uid)
                        .collection("userChannels")
                        .doc(randomId)
                        .set(channelData);
                    await FirebaseFirestore.instance
                        .collection("messages")
                        .doc(randomId)
                        .set(channelData);
                    isLoading.value = false;
                    Get.back();
                  }
                }
              } catch (error) {
                isLoading.value = false;
              }
            },
            child: Container(
              height: 55,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFF006aff),
              ),
              child: Center(
                child: Obx(
                  () => isLoading.value
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text(
                          "Create",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                          ),
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
