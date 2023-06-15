import 'package:chatting_application/screens/onboarding/privacy_policy.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../widget/contributors.dart';

class CustomSettings extends StatelessWidget {
  List items = [
    "Contributors",
    "Source Code",
    "Privacy Policy",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          "Settings",
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Colors.black,
          ),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (int i = 0; i < items.length; i++)
            GestureDetector(
              onTap: () {
                if (i == 0) {
                  Get.to(() => Contributors(), transition: Transition.fadeIn);
                } else if (i == 1) {
                  launchUrl(Uri.parse("https://github.com/chitraarasu/Jabber"));
                } else if (i == 2) {
                  Get.to(() => PrivacyPolicyScreen(isFromInsideApp: true),
                      transition: Transition.fadeIn);
                }
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Card(
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        Text(
                          items[i],
                          style: TextStyle(
                            fontSize: 25,
                          ),
                        ),
                        Spacer(),
                        Icon(Icons.arrow_forward_ios_rounded)
                      ],
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
