import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class JoinChannel extends StatelessWidget {
  JoinChannel({
    Key? key,
    required FirebaseAuth auth,
  })  : _auth = auth,
        super(key: key);

  final FirebaseAuth _auth;
  TextEditingController channelId = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var isLoading = false.obs;

    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                  border: Border.all(
                    width: 2,
                    color: Colors.blueGrey,
                  )),
              child: TextField(
                maxLines: 1,
                controller: channelId,
                style: const TextStyle(color: Colors.blueGrey),
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(12.5),
                  hintText: 'Enter channel ID',
                  border: InputBorder.none,
                  hintStyle: TextStyle(
                    color: Colors.blueGrey,
                  ),
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () async {
              try {
                if (!isLoading.value) {
                  if (channelId.text.trim().isNotEmpty) {
                    isLoading.value = true;
                    var channelList;
                    await FirebaseFirestore.instance
                        .collection("messages")
                        .get()
                        .then(
                      (data) {
                        channelList = data.docs;
                      },
                    );
                    for (var item in channelList) {
                      if (channelId.text == item["channelId"]) {
                        await FirebaseFirestore.instance
                            .collection("users")
                            .doc(_auth.currentUser?.uid)
                            .collection("userChannels")
                            .doc(item["channelId"])
                            .set({
                          'channelId': item["channelId"],
                          'channelName': item["channelName"],
                          'channelOwnerId': item["channelOwnerId"],
                          'channelProfile': item["channelProfile"],
                          "recentMessage": "hi",
                          "time": "12.00 am",
                        });
                      }
                    }
                    isLoading.value = false;
                    Get.back();
                  }
                }
              } catch (error) {
                isLoading.value = false;
              }
            },
            child: Container(
              height: 55,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFF006aff),
              ),
              child: Center(
                child: Obx(
                  () => isLoading.value
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text(
                          "Join",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                          ),
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
