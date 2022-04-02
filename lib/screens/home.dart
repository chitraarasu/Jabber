import 'package:chatting_application/screens/create_new_channel_or_join_channel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/controller.dart';
import '../widget/customMaterialButton.dart';
import 'onboarding_page.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var data = Get.put(Controller());

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      var preProfileData;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .get()
          .then((value) {
        preProfileData = value.data();
      });
      if (preProfileData == null) {
        FirebaseAuth.instance.signOut();
        Get.offAll(const OnBoardingPage(), transition: Transition.fade);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFfcfcfc),
      body: GetBuilder<Controller>(
        builder: (controller) => controller.body,
      ),
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Visibility(
        visible: MediaQuery.of(context).viewInsets.bottom == 0.0,
        child: FloatingActionButton(
          onPressed: () {
            Get.to(() => const CreateNewChannelOrJoinChannel());
          },
          backgroundColor: const Color(0xFF006aff),
          child: const Icon(Icons.edit),
        ),
      ),
    );
  }

  Widget get bottomNavigationBar {
    return GetBuilder<Controller>(
      builder: (controller) => BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 7.5,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomMaterialButton(() {
                controller.setScreen(0);
              }, controller.index == 0, Icons.messenger, "Chats"),
              CustomMaterialButton(() {
                controller.setScreen(1);
              }, controller.index == 1, Icons.phone, "Calls"),
              const SizedBox(
                width: 5,
              ),
              CustomMaterialButton(() {
                controller.setScreen(2);
              }, controller.index == 2, Icons.person_rounded, "Chat Bot"),
              CustomMaterialButton(() {
                controller.setScreen(3);
              }, controller.index == 3, Icons.settings, "Settings"),
            ],
          ),
        ),
      ),
    );
  }
}
