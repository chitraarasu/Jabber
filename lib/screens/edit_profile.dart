import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditProfile extends StatelessWidget {
  final data;
  EditProfile(this.data);

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _aboutController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    _nameController.value = _nameController.value.copyWith(
      text: data.get('username'),
    );
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        actions: [
          GestureDetector(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Icon(
                Icons.save,
                color: Colors.black,
              ),
            ),
          ),
        ],
        centerTitle: true,
        title: const Text(
          "Edit Profile",
          style: TextStyle(
            color: Colors.black,
            letterSpacing: 1,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 65,
                              backgroundColor: Color(0xFFedeff0),
                              backgroundImage: data.get('profileUrl') == null
                                  ? null
                                  : NetworkImage(data.get('profileUrl')),
                              child: data.get('profileUrl') != null
                                  ? null
                                  : Icon(
                                      Icons.add_a_photo_rounded,
                                      size: 65,
                                      color: Colors.blueGrey,
                                    ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: FloatingActionButton.small(
                                onPressed: () {
                                  // _takePicture();
                                },
                                child: const Icon(Icons.edit),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          data.get('username'),
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          data.get('phoneNumber'),
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    "Username",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey,
                    ),
                  ),
                  TextField(
                    controller: _nameController,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textCapitalization: TextCapitalization.sentences,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    "Email Address",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey,
                    ),
                  ),
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    "About",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey,
                    ),
                  ),
                  TextField(
                    controller: _aboutController,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textCapitalization: TextCapitalization.sentences,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
