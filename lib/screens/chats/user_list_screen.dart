import 'package:chatting_application/controller/controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

class ChannelUserList extends StatelessWidget {
  final channelId;

  const ChannelUserList({Key? key, this.channelId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    HomeController homeController = Get.find();

    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("messages")
          .doc(channelId)
          .collection('channelMembers')
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: SpinKitFadingCircle(
                color: Color(0xFF006aff),
                size: 45.0,
                duration: Duration(milliseconds: 900),
              ),
            ),
          );
        } else if (snapshot.hasData) {
          List channelUsers =
              snapshot.data.docs.map((e) => e.data()["userId"]).toList();

          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.white,
              title: Text(
                "${snapshot.data.docs.length} Participants",
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
              children: [
                Expanded(
                  child: FutureBuilder(
                    future:
                        FirebaseFirestore.instance.collection("users").get(),
                    builder:
                        (BuildContext context, AsyncSnapshot<dynamic> snp) {
                      if (snp.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: SpinKitFadingCircle(
                            color: Color(0xFF006aff),
                            size: 45.0,
                            duration: Duration(milliseconds: 900),
                          ),
                        );
                      } else if (snp.hasData) {
                        List userList =
                            snp.data.docs.map((item) => item.data()).toList();

                        userList.removeWhere((element) =>
                            !channelUsers.contains(element["uid"]));

                        return ListView.builder(
                          itemCount: userList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              child: Card(
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.grey,
                                    backgroundImage:
                                        userList[index]['profileUrl'] == null
                                            ? null
                                            : NetworkImage(
                                                userList[index]['profileUrl']),
                                  ),
                                  title: Text(userList[index]['username']),
                                  subtitle:
                                      Text(userList[index]['phoneNumber']),
                                ),
                              ),
                            );
                          },
                        );
                      } else {
                        return const Center(
                          child: Text("Check your internet connection."),
                        );
                      }
                    },
                  ),
                ),
                homeController.getAdsWidget(),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          );
        } else {
          return const Center(
            child: Text("Check your internet connection."),
          );
        }
      },
    );
  }
}
