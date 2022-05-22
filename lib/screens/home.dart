import 'package:animations/animations.dart';
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
  final _fabDimension = 56.0;
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
      // body: GetBuilder<Controller>(
      //   builder: (controller) => controller.body,
      // ),
      body: GetBuilder<Controller>(
        builder: (controller) => PageTransitionSwitcher(
          transitionBuilder: (
            Widget child,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) {
            return FadeThroughTransition(
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              child: child,
            );
          },
          child: controller.body,
        ),
      ),
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Visibility(
        visible: MediaQuery.of(context).viewInsets.bottom == 0.0,
        // child: FloatingActionButton(
        //   onPressed: () {
        //     Get.to(() => const CreateNewChannelOrJoinChannel());
        //   },
        //   backgroundColor: const Color(0xFF006aff),
        //   child: const Icon(Icons.edit),
        // ),
        child: OpenContainer(
          transitionType: ContainerTransitionType.fade,
          openBuilder: (BuildContext context, VoidCallback _) {
            return const CreateNewChannelOrJoinChannel();
          },
          closedElevation: 6.0,
          closedShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(_fabDimension / 2),
            ),
          ),
          closedColor: Theme.of(context).colorScheme.secondary,
          closedBuilder: (BuildContext context, VoidCallback openContainer) {
            return Container(
              color: const Color(0xFF006aff),
              child: SizedBox(
                height: _fabDimension,
                width: _fabDimension,
                child: Center(
                  child: Icon(
                    Icons.add,
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget get bottomNavigationBar {
    var mediaData = MediaQuery.of(context).size;
    return GetBuilder<Controller>(
      builder: (controller) => BottomAppBar(
        clipBehavior: Clip.hardEdge,
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
              }, controller.index == 1, Icons.music_note_rounded, "Music"),
              SizedBox(
                width: mediaData.width * .05,
              ),
              CustomMaterialButton(() {
                controller.setScreen(2);
              }, controller.index == 2, Icons.newspaper_rounded, "News"),
              CustomMaterialButton(() {
                controller.setScreen(3);
              }, controller.index == 3, Icons.account_box_rounded, "Profile"),
            ],
          ),
        ),
      ),
    );
  }
}
