import 'package:animations/animations.dart';
import 'package:chatting_application/screens/contacts.dart';
import 'package:chatting_application/screens/create_new_channel_or_join_channel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/controller.dart';
import '../../utils/contact_group_clip.dart';
import '../../widget/customMaterialButton.dart';
import '../onboarding/onboarding_page.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
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

  RxBool isFavTabVisible = RxBool(false);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xFFfcfcfc),
      // body: GetBuilder<Controller>(
      //   builder: (controller) => controller.body,
      // ),
      body: GestureDetector(
        onTap: () {
          if (isFavTabVisible.value) {
            isFavTabVisible.value = false;
          }
        },
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            GetBuilder<HomeController>(
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
            Obx(
              () => AnimatedPositioned(
                bottom: isFavTabVisible.value ? 0 : -40,
                duration: Duration(milliseconds: 250),
                child: Padding(
                  padding: EdgeInsets.only(bottom: _fabDimension / 2 + 10),
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 250),
                    height: isFavTabVisible.value ? 110 : 0,
                    width: isFavTabVisible.value ? width * .55 : 0,
                    child: AnimatedOpacity(
                      duration: Duration(milliseconds: 250),
                      opacity: isFavTabVisible.value ? 1 : 0,
                      child: CustomPaint(
                        size: Size(
                            width, (width * 0.7142857142857143).toDouble()),
                        painter: RPSCustomPainter(),
                        child: Row(
                            children: [
                          {"id": 0, "title": "Contact", "icon": "contacts.png"},
                          {"id": 1, "title": "Group", "icon": "people.png"}
                        ]
                                .map((item) => Expanded(
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: OpenContainer(
                                              transitionType:
                                                  ContainerTransitionType.fade,
                                              openBuilder:
                                                  (BuildContext context,
                                                      VoidCallback _) {
                                                if (item["id"] == 0) {
                                                  return Contacts();
                                                } else {
                                                  return const CreateNewChannelOrJoinChannel();
                                                }
                                              },
                                              openElevation: 0,
                                              closedElevation: 0,
                                              closedColor: Colors.transparent,
                                              onClosed: (data) {
                                                isFavTabVisible.value = false;
                                              },
                                              closedBuilder: (BuildContext
                                                      context,
                                                  VoidCallback openContainer) {
                                                return Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Image(
                                                      image: AssetImage(
                                                          "assets/images/${item["icon"]}"),
                                                      width: 45,
                                                    ),
                                                    SizedBox(height: 4),
                                                    Text(
                                                      item["title"].toString(),
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    )
                                                  ],
                                                );
                                              },
                                            ),
                                          ),
                                          if (item["id"] == 0)
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 15),
                                              child: DottedLine(
                                                direction: Axis.vertical,
                                                lineLength: double.infinity,
                                                lineThickness: 2.0,
                                                dashLength: 10.0,
                                                dashColor: Color(0xFF86898f),
                                                dashGapLength: 6.0,
                                              ),
                                            )
                                        ],
                                      ),
                                    ))
                                .toList()),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
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
        child: GestureDetector(
          onTap: () {
            isFavTabVisible.value = !isFavTabVisible.value;
          },
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF006aff),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 3,
                  blurRadius: 3,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: SizedBox(
              height: _fabDimension,
              width: _fabDimension,
              child: Center(
                child: Obx(
                  () => Icon(
                    isFavTabVisible.value ? Icons.clear : Icons.add,
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget get bottomNavigationBar {
    var mediaData = MediaQuery.of(context).size;
    return GetBuilder<HomeController>(
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
              // CustomMaterialButton(() {
              //   controller.setScreen(1);
              // }, controller.index == 1, Icons.music_note_rounded, "Music"),
              // SizedBox(
              //   width: mediaData.width * .05,
              // ),
              // CustomMaterialButton(() {
              //   controller.setScreen(2);
              // }, controller.index == 2, Icons.newspaper_rounded, "News"),
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
