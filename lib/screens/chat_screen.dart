import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:rive/rive.dart';
import '../widget/chat_profile_sheet.dart';
import '../widget/image_view.dart';
import '../widget/message_bubble.dart';

class ChatScreen extends StatelessWidget {
  final name;
  final image;
  final channelId;
  ChatScreen(this.name, this.image, this.channelId);

  @override
  Widget build(BuildContext context) {
    var _enteredMessage = ''.obs;
    TextEditingController _controller = TextEditingController();

    void _sendMessage() async {
      _controller.clear();

      FocusScope.of(context).unfocus();
      final user = FirebaseAuth.instance.currentUser!;
      final userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      FirebaseFirestore.instance
          .collection('messages')
          .doc(channelId)
          .collection("channelChat")
          .add({
        'message': _enteredMessage.value,
        'createdTime': Timestamp.now(),
        'senderId': user.uid,
        'senderName': userData['username'],
      });
      FirebaseFirestore.instance.collection('messages').doc(channelId).update({
        'recentMessage': _enteredMessage.value,
        'time': Timestamp.now(),
      });
      FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection("userChannels")
          .doc(channelId)
          .update({
        'recentMessage': _enteredMessage.value,
        'time': Timestamp.now(),
      });
    }

    return Scaffold(
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
                  heightFactor: 0.70,
                  child: ChatProfileSheet(name, image, channelId),
                );
              },
            );
          },
          child: Row(
            children: [
              Hero(
                tag: name,
                child: CircleAvatar(
                  backgroundColor: const Color(0xFFd6e2ea),
                  backgroundImage: image == null ? null : NetworkImage(image),
                  child: image == null
                      ? const Icon(
                          Icons.person_rounded,
                          color: Colors.grey,
                          size: 30,
                        )
                      : null,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  name,
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
          IconButton(
            onPressed: () {},
            icon: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.deepOrange,
              ),
              child: const Icon(Icons.search),
            ),
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
                  .collection('messages')
                  .doc(channelId)
                  .collection('channelChat')
                  .orderBy(
                    'createdTime',
                    descending: true,
                  )
                  .snapshots(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
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
                      reverse: true,
                      itemCount: docs.length,
                      itemBuilder: (ctx, index) {
                        var time = DateFormat('hh:mm a').format(
                          Timestamp(docs[index]["createdTime"].seconds,
                                  docs[index]["createdTime"].nanoseconds)
                              .toDate(),
                        );
                        return MessageBubble(
                          docs[index]['message'],
                          docs[index]['senderId'] == currentUser,
                          docs[index]['senderName'],
                          time,
                        );
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
                    padding:
                        const EdgeInsets.only(top: 8.0, left: 8.0, bottom: 8.0),
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
                              onPressed: () {},
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
                                minLines: 1,
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
                                print(result);
                                Get.to(() => CustomImageView(),
                                    transition: Transition.zoom);
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
        ],
      ),
    );
  }
}
