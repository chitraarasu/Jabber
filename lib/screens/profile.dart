import 'dart:ui';

import 'package:chatting_application/screens/edit_profile.dart';
import 'package:chatting_application/screens/settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/controller.dart';
import 'my_groups.dart';
import 'onboarding_page.dart';

class Profile extends StatelessWidget {
  List buttonList = [
    "😴 Away",
    "💻 At Work",
    "🎮 Gaming",
    "🆓 Free",
    "📖 Study",
  ];
  final FirebaseAuth _auth = FirebaseAuth.instance;

  _displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Do you want to logout?'),
            actions: <Widget>[
              TextButton(
                child: const Text('No'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text(
                  'Yes',
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  Get.find<Controller>().setScreen(0);
                  _auth.signOut();
                  Get.offAll(const OnBoardingPage(),
                      transition: Transition.fade);
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Profile",
          style: TextStyle(
            color: Colors.black,
            letterSpacing: 1,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(_auth.currentUser?.uid)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            var docs = snapshot.data;
            return SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Color(0xFFf4f5f7),
                                radius: 40,
                                backgroundImage: docs.get('profileUrl') == null
                                    ? null
                                    : NetworkImage(docs.get('profileUrl')),
                              ),
                              SizedBox(
                                width: 25,
                              ),
                              Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        docs.get('username'),
                                        style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        docs.get('phoneNumber'),
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              Get.to(() => EditProfile(docs),
                                  transition: Transition.rightToLeftWithFade);
                            },
                          ),
                        ],
                      ),
                      // SizedBox(
                      //   height: 20,
                      // ),
                      // Text(
                      //   "My Status",
                      //   style: TextStyle(
                      //     fontSize: 20,
                      //     fontWeight: FontWeight.w400,
                      //     color: Colors.grey,
                      //   ),
                      // ),
                      // GetBuilder<Controller>(
                      //   init: Controller(),
                      //   builder: (getController) => Container(
                      //     margin: EdgeInsets.only(top: 10),
                      //     height: 45.0,
                      //     child: ListView.builder(
                      //       scrollDirection: Axis.horizontal,
                      //       itemBuilder: (BuildContext context, int index) {
                      //         return TopButton(
                      //           index: index,
                      //           buttonTitle: buttonList[index],
                      //           tagDataMethod: (isSelected) async {
                      //             getController
                      //                 .setValue(isSelected ? index : null);
                      //           },
                      //           value: getController.value,
                      //         );
                      //       },
                      //       itemCount: buttonList.length,
                      //     ),
                      //   ),
                      // ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Dashboard",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      CustomTile("Groups", Icons.group_rounded, Colors.green,
                          () {
                        Get.to(() => MyGroups(),
                            transition: Transition.rightToLeftWithFade);
                      }),
                      // CustomTile("Block List", Icons.block_rounded,
                      //     Colors.yellow, () {}),
                      CustomTile(
                          "Settings", Icons.settings_rounded, Colors.grey, () {
                        Get.to(() => CustomSettings(),
                            transition: Transition.rightToLeftWithFade);
                      }),

                      // Row(
                      //   children: [
                      //     TextButton(
                      //       onPressed: () {},
                      //       child: Text(
                      //         "Switch to Other Account",
                      //         style:
                      //             TextStyle(color: Colors.blue, fontSize: 18),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      Row(
                        children: [
                          TextButton(
                            onPressed: () {
                              _displayDialog(context);
                            },
                            child: Text(
                              "Log Out",
                              style: TextStyle(color: Colors.red, fontSize: 18),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

class CustomTile extends StatelessWidget {
  final topic;
  final color;
  final icon;
  Function onTap;
  CustomTile(this.topic, this.icon, this.color, this.onTap);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: color,
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Text(
                  topic,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 25,
              color: Colors.black,
            )
          ],
        ),
      ),
    );
  }
}

class TopButton extends StatelessWidget {
  final buttonTitle;
  Function tagDataMethod;
  final index;
  final value;

  TopButton({
    this.buttonTitle,
    required this.tagDataMethod,
    this.index,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 5.0),
      child: Wrap(
        children: [
          ChoiceChip(
            onSelected: (isSelected) {
              tagDataMethod(isSelected);
            },
            label: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                buttonTitle,
                style: TextStyle(color: Colors.white),
              ),
            ),
            backgroundColor: Colors.blue,
            selectedColor: Color(0xFF003F9C),
            selected: value == index,
          ),
        ],
      ),
    );
  }
}
