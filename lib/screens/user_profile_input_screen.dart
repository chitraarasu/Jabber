import 'dart:io';

import 'package:chatting_application/controller/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class UserProfileInputScreen extends StatelessWidget {
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
      Get.find<Controller>().setUserProfileImage(File(imageFile!.path),);
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Profile info",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black,
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
                    height: 20,
                  ),
                  const Text(
                    "Please provide your name and an optional profile photo",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22.5,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Stack(
                    children: [
                      GetBuilder<Controller>(
                  init: Controller(),
                        builder: (getController) =>  CircleAvatar(
                          radius: 65,
                          backgroundColor: const Color(0xFFd6e2ea),
                          child: getController.userProfileImage != null
                              ? Image.file(
                            getController.userProfileImage,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                )
                              : const Icon(
                                  Icons.camera_alt_rounded,
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
                        const Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              label: Text('Enter your name'),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: const Color(0xFFd6e2ea),
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
                  onPressed: () {},
                  child: const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text("Next"),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
