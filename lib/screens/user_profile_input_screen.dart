import 'dart:io';

import 'package:chatting_application/controller/controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'home.dart';

class UserProfileInputScreen extends StatefulWidget {
  @override
  State<UserProfileInputScreen> createState() => _UserProfileInputScreenState();
}

class _UserProfileInputScreenState extends State<UserProfileInputScreen> {
  TextEditingController nameController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  var isLoading = false.obs;

  var getController = Get.put(Controller());

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    PickedFile? imageFile;
    Future _takePicture() async {
      imageFile = await ImagePicker.platform.pickImage(
        source: ImageSource.gallery,
        maxWidth: 600,
      );
      if (imageFile == null) {
        return;
      }
      Get.find<Controller>().setUserProfileImage(
        File(imageFile!.path),
      );
    }

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[Colors.deepOrange, Colors.deepOrangeAccent],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            "Profile info",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
            ),
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Step 03/03",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Please provide your name and an optional profile photo",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22.5,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Stack(
                      children: [
                        GetBuilder<Controller>(
                          init: Controller(),
                          builder: (getController) => CircleAvatar(
                            radius: 65,
                            backgroundColor: Colors.white,
                            backgroundImage:
                                getController.userProfileImage != null
                                    ? FileImage(
                                        getController.userProfileImage,
                                      )
                                    : null,
                            child: getController.userProfileImage != null
                                ? null
                                : const Icon(
                                    Icons.add_a_photo_rounded,
                                    size: 65,
                                    color: Colors.blueGrey,
                                  ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: FloatingActionButton.small(
                            onPressed: () {
                              _takePicture();
                            },
                            child: const Icon(Icons.edit),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(10.0),
                                  ),
                                  border: Border.all(
                                    width: 2,
                                    color: Colors.white,
                                  )),
                              child: TextField(
                                textCapitalization:
                                    TextCapitalization.sentences,
                                maxLines: 1,
                                controller: nameController,
                                style: const TextStyle(color: Colors.white),
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.all(12.5),
                                  hintText: 'Enter your name',
                                  border: InputBorder.none,
                                  hintStyle: TextStyle(
                                    color: Colors.white,
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
                              color: Colors.white,
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.insert_emoticon,
                                size: 40,
                                color: Colors.blueGrey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all(0),
                    ),
                    onPressed: () async {
                      try {
                        if (!isLoading.value) {
                          if (nameController.text.trim().isNotEmpty) {
                            isLoading.value = true;
                            var url;
                            var preProfileData;
                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(_auth.currentUser?.uid)
                                .get()
                                .then((value) {
                              preProfileData = value.data();
                            });
                            if (preProfileData != null) {
                              url = preProfileData['profileUrl'];
                            }
                            if (getController.userProfileImage != null) {
                              final ref = FirebaseStorage.instance
                                  .ref()
                                  .child('user_image')
                                  .child("${_auth.currentUser?.uid}.jpg");
                              await ref.putFile(getController.userProfileImage);
                              url = await ref.getDownloadURL();
                            }
                            await FirebaseFirestore.instance
                                .collection("users")
                                .doc(_auth.currentUser?.uid)
                                .set({
                              'username': nameController.text,
                              'phoneNumber': _auth.currentUser?.phoneNumber,
                              'isOnline': true,
                              'profileUrl': url,
                              "uid": _auth.currentUser?.uid,
                            });
                            isLoading.value = false;
                            Get.offAll(
                              () => const Home(),
                              transition: Transition.rightToLeftWithFade,
                            );
                          }
                        }
                      } catch (error) {
                        isLoading.value = false;
                      }
                    },
                    child: Obx(
                      () => Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: isLoading.value
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text("Next"),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
