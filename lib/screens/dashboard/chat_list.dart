import 'package:chatting_application/widget/search.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import '../../widget/chat_bar.dart';
import '../../widget/empty_screen.dart';
import '../chats/bot.dart';
import '../chats/chat_screen.dart';
import '../contacts.dart';

class ChatList extends StatefulWidget {
  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final box = GetStorage();
  var groups = [];

  RxString selectedListType = RxString("private-chat");
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    groups = [];
    if (box.read("selectedTab") != null) {
      selectedListType.value = box.read("selectedTab");
    }
  }

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
          IconButton(
            onPressed: () {},
            icon: ImageIcon(
              AssetImage("assets/images/letter.png"),
              size: 30,
              color: Colors.black,
            ),
          ),
          SizedBox(width: 10)
          // Padding(
          //   padding: const EdgeInsets.only(right: 15.0),
          //   child: GestureDetector(
          //     onTap: () {
          //       Get.to(() => Chat());
          //     },
          //     child: Tab(
          //       icon: Lottie.asset(
          //         'assets/animations/bot-icon.json',
          //         width: 45,
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Search(),
                ),
                SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: Container(
                    height: 45.0,
                    decoration: const BoxDecoration(
                      color: Color(0xFFebebec),
                      borderRadius: BorderRadius.all(
                        Radius.circular(25.0),
                      ),
                    ),
                    child: Row(
                        children: ["private-chat", "people"]
                            .map(
                              (e) => Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    selectedListType.value = e;
                                    box.write("selectedTab", e);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Obx(
                                      () => AnimatedContainer(
                                        duration: Duration(seconds: 1),
                                        decoration: selectedListType.value != e
                                            ? null
                                            : BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(25.0),
                                                ),
                                                border: Border.all(
                                                  width: 1.5,
                                                  color: Color(0x9d575757),
                                                ),
                                              ),
                                        child: Center(
                                          child: Image(
                                            width: 30,
                                            image: AssetImage(
                                                "assets/images/$e.png"),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                            .toList()),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Expanded(
              child: Obx(
                () => selectedListType.value == "private-chat"
                    ? StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection("private_chats")
                            .where('chat_members',
                                arrayContains: _auth.currentUser?.uid)
                            .orderBy(
                              'createdTime',
                              descending: true,
                            )
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<dynamic> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const SpinKitFadingCircle(
                              color: Color(0xFF006aff),
                              size: 45.0,
                              duration: Duration(milliseconds: 900),
                            );
                          } else if (snapshot.hasData) {
                            List docs = snapshot.data.docs;
                            List chatData = docs.map((e) => e.data()).toList();
                            var receivers = [];
                            for (var e in chatData) {
                              List data = e["chat_members"];
                              data.remove(_auth.currentUser?.uid);
                              receivers.add(data.first);
                            }
                            print(receivers);
                            if (chatData.isEmpty) {
                              return const EmptyScreen();
                            } else {
                              return FutureBuilder(
                                future: FirebaseFirestore.instance
                                    .collection("users")
                                    .where('uid', whereIn: receivers)
                                    .get(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<dynamic> snp) {
                                  if (snp.connectionState ==
                                      ConnectionState.waiting) {
                                    return const SpinKitFadingCircle(
                                      color: Color(0xFF006aff),
                                      size: 45.0,
                                      duration: Duration(milliseconds: 900),
                                    );
                                  } else if (snp.hasData) {
                                    List users = snp.data.docs;
                                    List usersData =
                                        users.map((e) => e.data()).toList();
                                    for (var user in usersData) {
                                      for (var e in chatData) {
                                        List data = e["chat_members"];
                                        data.remove(_auth.currentUser?.uid);
                                        if (user["uid"] == data.first) {
                                          e["userData"] = user;
                                        }
                                      }
                                    }
                                    return ListView.builder(
                                      physics: const BouncingScrollPhysics(),
                                      itemCount: chatData.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        var time = DateFormat('hh:mm a').format(
                                          Timestamp(
                                                  chatData[index]["createdTime"]
                                                      .seconds,
                                                  chatData[index]["createdTime"]
                                                      .nanoseconds)
                                              .toDate(),
                                        );
                                        var user = chatData[index]["userData"];
                                        return ChatBar(
                                          chatData[index]["chat_id"],
                                          user["username"],
                                          chatData[index]["recentMessage"]
                                                  .toString()
                                                  .contains(
                                                      "https://firebasestorage.googleapis.com/v0/b/csp-chatting-app.appspot.com/o/user_data")
                                              ? 'Image'
                                              : chatData[index]
                                                  ["recentMessage"],
                                          user["profileUrl"],
                                          time,
                                          "",
                                          () {
                                            Get.to(
                                              () => ChatScreen(
                                                user["username"],
                                                user["profileUrl"],
                                                chatData[index]['chat_id'],
                                                isForSingleChatList: true,
                                                reciverData: user,
                                              ),
                                              transition: Transition
                                                  .rightToLeftWithFade,
                                            );
                                          },
                                          () {
                                            // final user =
                                            //     FirebaseAuth.instance.currentUser!;
                                            // FirebaseFirestore.instance
                                            //     .collection('users')
                                            //     .doc(user.uid)
                                            //     .collection("userChannels")
                                            //     .doc(docs[index]['channelId'])
                                            //     .delete();
                                          },
                                        );
                                      },
                                    );
                                  } else {
                                    return const EmptyScreen();
                                  }
                                },
                              );
                            }
                          } else {
                            return const EmptyScreen();
                          }
                        },
                      )
                    : StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection("users")
                            .doc(_auth.currentUser?.uid)
                            .collection("userChannels")
                            .orderBy(
                              'time',
                              descending: true,
                            )
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<dynamic> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const SpinKitFadingCircle(
                              color: Color(0xFF006aff),
                              size: 45.0,
                              duration: Duration(milliseconds: 900),
                            );
                          } else if (!snapshot.hasData || snapshot.hasError) {
                            return const EmptyScreen();
                          } else {
                            List docs = snapshot.data.docs;
                            FirebaseFirestore.instance
                                .collection('messages')
                                .get()
                                .then((items) {
                              for (var item in items.docs) {
                                groups.add(item['channelId']);
                              }
                              for (var element in docs) {
                                if (!groups.contains(element["channelId"])) {
                                  FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(FirebaseAuth
                                          .instance.currentUser!.uid)
                                      .collection("userChannels")
                                      .doc(element["channelId"])
                                      .delete();
                                }
                              }
                            });

                            if (docs.isEmpty) {
                              return const EmptyScreen();
                            } else {
                              return ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                itemCount: docs.length,
                                itemBuilder: (BuildContext context, int index) {
                                  var time = DateFormat('hh:mm a').format(
                                    Timestamp(docs[index]["time"].seconds,
                                            docs[index]["time"].nanoseconds)
                                        .toDate(),
                                  );
                                  return ChatBar(
                                    docs[index]["channelId"],
                                    docs[index]["channelName"],
                                    docs[index]["recentMessage"]
                                            .toString()
                                            .contains(
                                                "https://firebasestorage.googleapis.com/v0/b/csp-chatting-app.appspot.com/o/user_data")
                                        ? 'Image'
                                        : docs[index]["recentMessage"],
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
                                },
                              );
                            }
                          }
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
