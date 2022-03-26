import 'package:chatting_application/screens/chat_screen.dart';
import 'package:chatting_application/screens/onboarding_page.dart';
import 'package:chatting_application/widget/search.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../widget/chat_bar.dart';

class ChatList extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  var length = 0;

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
              child: length == 0
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset(
                          "assets/animations/empty.json",
                        ),
                        const Text("Start chat with your friends and family"),
                      ],
                    )
                  : ListView.builder(
                      itemCount: length,
                      itemBuilder: (BuildContext context, int index) => ChatBar(
                        "Alice hendry",
                        "Great i will have a look",
                        "https://chitraarasu-portfolio.herokuapp.com/assets/Passport.webp",
                        "12.33 AM",
                        "3",
                        () {
                          Get.to(
                              () => ChatScreen(
                                    "Alice hendry",
                                    "https://chitraarasu-portfolio.herokuapp.com/assets/Passport.webp",
                                  ),
                              transition: Transition.rightToLeftWithFade);
                        },
                      ),
                    ),
            )
          ],
        ),
      ),
    );
  }
}
