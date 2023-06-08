import 'package:chatting_application/controller/controller.dart';
import 'package:chatting_application/model/notification.dart';
import 'package:chatting_application/screens/chats/schedule_screen.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:workmanager/workmanager.dart';
import '../../widget/chat_profile_sheet.dart';
import '../../widget/image_view.dart';
import '../../widget/message_bubble.dart';

class ChatScreen extends StatefulWidget {
  final name;
  final image;
  final channelId;
  final isForSingleChatList;
  final reciverData;
  ChatScreen(this.name, this.image, this.channelId,
      {this.isForSingleChatList = false, this.reciverData});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  FocusNode focusNode = FocusNode();
  var isEmojiVisible = false.obs;
  HomeController homeController = Get.find();

  @override
  Widget build(BuildContext context) {
    var _enteredMessage = ''.obs;
    TextEditingController _controller = TextEditingController();

    void _sendMessage() async {
      _controller.clear();

      final user = FirebaseAuth.instance.currentUser!;

      final userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (widget.isForSingleChatList) {
        FirebaseFirestore.instance
            .collection('private_chats')
            .doc(widget.channelId)
            .collection("channelChat")
            .add({
          'message': _enteredMessage.value,
          'messageType': "text",
          'createdTime': Timestamp.now(),
          'senderId': user.uid,
          'senderName': userData['username'],
        });

        FirebaseFirestore.instance
            .collection('private_chats')
            .doc(widget.channelId)
            .set({
          'chat_id': widget.channelId,
          'messageType': "text",
          'createdTime': Timestamp.now(),
          'chat_members': [user.uid, widget.reciverData["uid"]],
          'senderName': userData['username'],
          'recentMessage': _enteredMessage.value,
        });

        homeController.sendNotification(
          data: {},
          tokens: [widget.reciverData["token"]],
          name: userData['username'],
          message: _enteredMessage.value,
        );
      } else {
        FirebaseFirestore.instance
            .collection('messages')
            .doc(widget.channelId)
            .collection("channelChat")
            .add({
          'message': _enteredMessage.value,
          'messageType': "text",
          'createdTime': Timestamp.now(),
          'senderId': user.uid,
          'senderName': userData['username'],
        });

        FirebaseFirestore.instance
            .collection('messages')
            .doc(widget.channelId)
            .update({
          'recentMessage': _enteredMessage.value,
          'time': Timestamp.now(),
        });

        FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection("userChannels")
            .doc(widget.channelId)
            .update({
          'recentMessage': _enteredMessage.value,
          'time': Timestamp.now(),
        });

        // Notification
        FirebaseFirestore.instance
            .collection('messages')
            .doc(widget.channelId)
            .collection("channelMembers")
            .get()
            .then((value) {
          var channelMembers = [];
          for (var item in value.docs) {
            channelMembers.add(item.data()["userId"]);
          }
          FirebaseFirestore.instance
              .collection('users')
              .get()
              .then((usersData) {
            var userTokens = [];
            for (var item in usersData.docs) {
              if (channelMembers.contains(item.data()["uid"])) {
                userTokens.add(item.data()["token"]);
              }
            }
            homeController.sendNotification(
              data: {},
              tokens: userTokens,
              name: userData['username'],
              message: _enteredMessage.value,
            );
          });
        });
      }
    }

    Future<void> handleClick(String value) async {
      switch (value) {
        case 'Schedule message':
          Get.to(() => ScheduleMessage(widget.channelId),
              transition: Transition.rightToLeftWithFade);
          break;
        case 'Clear schedule':
          Workmanager().cancelByUniqueName(widget.channelId);
          Fluttertoast.showToast(
            msg: "Schedule cleared",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0,
          );
          break;
      }
    }

    return WillPopScope(
      onWillPop: () {
        if (isEmojiVisible.value) {
          isEmojiVisible.value = false;
        } else {
          Navigator.pop(context);
        }
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          toolbarHeight: 70,
          backgroundColor: Colors.white,
          titleSpacing: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: Colors.black,
            ),
            onPressed: () {
              Get.back();
            },
          ),
          title: GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) {
                  return FractionallySizedBox(
                    heightFactor: widget.isForSingleChatList ? 0.5 : 0.70,
                    child: ChatProfileSheet(widget.name, widget.image,
                        widget.channelId, widget.isForSingleChatList),
                  );
                },
              );
            },
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: const Color(0xFFd6e2ea),
                  backgroundImage:
                      widget.image == null ? null : NetworkImage(widget.image),
                  child: widget.image == null
                      ? const Icon(
                          Icons.person_rounded,
                          color: Colors.grey,
                          size: 30,
                        )
                      : null,
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Text(
                    widget.name,
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            // IconButton(
            //   onPressed: () {},
            //   icon: Container(
            //     padding: const EdgeInsets.all(4),
            //     decoration: const BoxDecoration(
            //       shape: BoxShape.circle,
            //       color: Colors.deepOrange,
            //     ),
            //     child: const Icon(Icons.phone),
            //   ),
            // ),
            if (!widget.isForSingleChatList)
              PopupMenuButton<String>(
                icon: Icon(
                  Icons.adaptive.more,
                  color: Colors.black,
                ),
                onSelected: handleClick,
                itemBuilder: (BuildContext context) {
                  return {'Schedule message', 'Clear schedule'}
                      .map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(choice),
                    );
                  }).toList();
                },
              ),
            const SizedBox(
              width: 10,
            ),
          ],
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection(widget.isForSingleChatList
                        ? "private_chats"
                        : 'messages')
                    .doc(widget.channelId)
                    .collection('channelChat')
                    .orderBy(
                      'createdTime',
                      descending: true,
                    )
                    .snapshots(),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    List docs = snapshot.data.docs;
                    final currentUser = FirebaseAuth.instance.currentUser?.uid;
                    if (docs.isEmpty) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Lottie.asset(
                                "assets/animations/no_data_found.json"),
                          ),
                          const Text("No messages here yet..."),
                        ],
                      );
                    } else {
                      return ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        reverse: true,
                        itemCount: docs.length,
                        itemBuilder: (ctx, index) {
                          var time = DateFormat('hh:mm a').format(
                            Timestamp(docs[index]["createdTime"].seconds,
                                    docs[index]["createdTime"].nanoseconds)
                                .toDate(),
                          );
                          if (docs[index]['messageType'] == "text") {
                            return MessageBubble(
                              docs[index]['message'],
                              docs[index]['senderId'] == currentUser,
                              docs[index]['senderName'],
                              time,
                            );
                          } else {
                            return ImageBubble(
                              docs[index]['message'],
                              docs[index]['senderId'] == currentUser,
                              docs[index]['senderName'],
                              time,
                            );
                          }
                        },
                      );
                    }
                  }
                },
              ),
            ),
            Container(
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 8.0, left: 8.0, bottom: 8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFf7f7f7),
                          border: Border.all(
                            width: 1,
                            color: Colors.grey,
                          ),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(25.0),
                          ),
                        ),
                        child: SizedBox(
                          height: 45.0,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              FloatingActionButton.small(
                                heroTag: const Text("btn1"),
                                elevation: 0,
                                disabledElevation: 0,
                                hoverElevation: 0,
                                highlightElevation: 0,
                                focusElevation: 0,
                                onPressed: () {
                                  isEmojiVisible.value = !isEmojiVisible.value;
                                  focusNode.unfocus();
                                  focusNode.canRequestFocus = true;
                                },
                                backgroundColor: Colors.transparent,
                                child: const Icon(
                                  Icons.insert_emoticon,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                child: TextField(
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  controller: _controller,
                                  focusNode: focusNode,
                                  minLines: 1,
                                  onTap: () {
                                    if (isEmojiVisible.value) {
                                      isEmojiVisible.value = false;
                                    }
                                  },
                                  maxLines: 5,
                                  keyboardType: TextInputType.multiline, //
                                  textInputAction: TextInputAction.newline,
                                  onChanged: (value) {
                                    _enteredMessage.value = value;
                                  },
                                  decoration: const InputDecoration(
                                    hintText: "Type your message here",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                              FloatingActionButton.small(
                                heroTag: const Text("btn2"),
                                elevation: 0,
                                disabledElevation: 0,
                                hoverElevation: 0,
                                highlightElevation: 0,
                                focusElevation: 0,
                                onPressed: () async {
                                  FilePickerResult? result =
                                      await FilePicker.platform.pickFiles(
                                          // allowMultiple: true,
                                          type: FileType.image);
                                  if (result != null) {
                                    Get.to(
                                        () => CustomImageView(
                                            result.files.first,
                                            widget.channelId,
                                            widget.isForSingleChatList,
                                            widget.reciverData),
                                        transition: Transition.zoom);
                                  }
                                },
                                backgroundColor: Colors.transparent,
                                child: const Icon(
                                  Icons.link_outlined,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Obx(
                    () => FloatingActionButton.small(
                      heroTag: const Text("btn3"),
                      elevation: 0,
                      disabledElevation: 0,
                      hoverElevation: 0,
                      highlightElevation: 0,
                      focusElevation: 0,
                      onPressed: _enteredMessage.trim().isEmpty
                          ? null
                          : () {
                              _sendMessage();
                            },
                      backgroundColor: Colors.deepOrange,
                      child: const Icon(
                        Icons.send_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Obx(
              () => Offstage(
                offstage: !isEmojiVisible.value,
                child: SizedBox(
                  height: 250,
                  child: EmojiPicker(
                    onEmojiSelected: (category, emoji) {
                      _controller.text = _controller.text + emoji.emoji;
                      _enteredMessage.value = _controller.text + emoji.emoji;
                    },
                    onBackspacePressed: () {},
                    config: const Config(
                        columns: 7,
                        verticalSpacing: 0,
                        horizontalSpacing: 0,
                        initCategory: Category.SMILEYS,
                        bgColor: Color(0xFFF2F2F2),
                        indicatorColor: Colors.blue,
                        iconColor: Colors.grey,
                        iconColorSelected: Colors.blue,
                        // progressIndicatorColor: Colors.blue,
                        // showRecentsTab: true,
                        recentsLimit: 28,
                        // noRecentsText: "No Recents",
                        // noRecentsStyle:
                        //     TextStyle(fontSize: 20, color: Colors.black26),
                        tabIndicatorAnimDuration: kTabScrollDuration,
                        categoryIcons: CategoryIcons(),
                        buttonMode: ButtonMode.MATERIAL),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
