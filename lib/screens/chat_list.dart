import 'package:chatting_application/screens/chat_screen.dart';
import 'package:chatting_application/screens/onboarding_page.dart';
import 'package:chatting_application/widget/search.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../widget/chat_bar.dart';
import '../widget/empty_screen.dart';

class ChatList extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
            padding: const EdgeInsets.only(right: 15.0),
            child: GestureDetector(
              onTap: () {},
              child: Tab(
                icon: Image.asset(
                  "assets/images/edit.png",
                  width: 30,
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
                    .collection("userChannels")
                    .orderBy(
                      'time',
                      descending: true,
                    )
                    .snapshots(),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SpinKitFadingCircle(
                      color: Color(0xFF006aff),
                      size: 45.0,
                      duration: Duration(milliseconds: 900),
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
                          var groups = [];
                          FirebaseFirestore.instance
                              .collection('messages')
                              .get()
                              .then((items) {
                            for (var item in items.docs) {
                              groups.add(item['channelId']);
                            }
                            if (!groups.contains(docs[index]["channelId"])) {
                              FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(FirebaseAuth.instance.currentUser!.uid)
                                  .collection("userChannels")
                                  .doc(docs[index]["channelId"])
                                  .delete();
                            }
                          });

                          var time = DateFormat('hh:mm a').format(
                            Timestamp(docs[index]["time"].seconds,
                                    docs[index]["time"].nanoseconds)
                                .toDate(),
                          );
                          return StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('messages')
                                .doc(docs[index]["channelId"])
                                .collection('channelChat')
                                .orderBy(
                                  'createdTime',
                                  descending: true,
                                )
                                .snapshots(),
                            builder: (BuildContext context,
                                AsyncSnapshot<dynamic> snapshot) {
                              if (snapshot.connectionState !=
                                  ConnectionState.waiting) {
                                return ChatBar(
                                  docs[index]["channelId"],
                                  docs[index]["channelName"],
                                  snapshot.data.docs.length == 0
                                      ? ""
                                      : snapshot.data.docs
                                                  .first['messageType'] ==
                                              'image'
                                          ? 'Image'
                                          : snapshot.data.docs.first['message'],
                                  docs[index]["channelProfile"],
                                  time,
                                  "3",
                                  () {
                                    Get.to(
                                      () => ChatScreen(
                                        docs[index]["channelName"],
                                        docs[index]["channelProfile"],
                                        docs[index]['channelId'],
                                      ),
                                      transition:
                                          Transition.rightToLeftWithFade,
                                    );
                                  },
                                  () {
                                    final user =
                                        FirebaseAuth.instance.currentUser!;
                                    FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(user.uid)
                                        .collection("userChannels")
                                        .doc(docs[index]['channelId'])
                                        .delete();
                                  },
                                );
                              }
                              return Container();
                            },
                          );
                        },
                      );
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
