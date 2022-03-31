import 'package:chatting_application/screens/chat_screen.dart';
import 'package:chatting_application/screens/onboarding_page.dart';
import 'package:chatting_application/widget/search.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../widget/chat_bar.dart';
import '../widget/empty_screen.dart';

class ChatList extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Messages",
          style: TextStyle(
            color: Colors.black,
            letterSpacing: 1,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                _auth.signOut();
                Get.offAll(const OnBoardingPage(), transition: Transition.fade);
              },
              child: Tab(
                icon: Image.asset(
                  "assets/images/edit.png",
                  width: 35,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15.0),
        child: Column(
          children: [
            Search(),
            const SizedBox(
              height: 5,
            ),
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("users")
                    .doc(_auth.currentUser?.uid)
                    .collection("myChat")
                    .snapshots(),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (!snapshot.hasData || snapshot.hasError) {
                    return const EmptyScreen();
                  } else {
                    List docs = snapshot.data.docs;
                    if (docs.isEmpty) {
                      return const EmptyScreen();
                    } else {
                      return ListView.builder(
                          itemCount: docs.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ChatBar(
                              docs[index]["receiverName"],
                              docs[index]["recentTextMessage"],
                              docs[index]["profileUrl"],
                              docs[index]["time"],
                              "3",
                              () {
                                Get.to(
                                    () => ChatScreen(
                                          docs[index]["receiverName"],
                                          docs[index]["receiverId"],
                                          docs[index]["profileUrl"],
                                          docs[index]["receiverPhoneNumber"],
                                          false,
                                          docs[index]['channelId'],
                                        ),
                                    transition: Transition.rightToLeftWithFade);
                              },
                            );
                          });
                    }
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
