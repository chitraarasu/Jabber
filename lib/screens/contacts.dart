import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:get/get.dart';

import '../widget/chat_bar.dart';
import 'chat_screen.dart';

class Contacts extends StatelessWidget {
  var dbPhoneNumbers = [];
  var userData = [];
  var contactPhoneNumbers = [];
  var contactProfiles = [];

  Future getContacts() async {
    if (await FlutterContacts.requestPermission()) {
      var contact = await FlutterContacts.getContacts(withProperties: true);

      for (var item in contact) {
        if (item.phones.isNotEmpty && item.phones.length == 1) {
          if (dbPhoneNumbers.contains(item.phones[0].normalizedNumber)) {
            contactPhoneNumbers.add(item.phones[0].normalizedNumber);
          }
        }
      }

      for (var item in userData) {
        if (contactPhoneNumbers.contains(item['phoneNumber'])) {
          contactProfiles.add(item);
        }
      }

      return contact;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Colors.black,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Select contact",
          style: TextStyle(
            color: Colors.black,
            letterSpacing: 1,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(
                  context: context,
                  delegate: MySearchDelegate(contactProfiles));
            },
            icon: const Icon(
              Icons.search,
              color: Colors.black,
            ),
          )
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("users").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.data != null) {
            List docs = snapshot.data.docs;
            docs.forEach((item) {
              dbPhoneNumbers.add(item["phoneNumber"]);
              userData.add(item);
            });
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Text("Loading..."),
            );
          } else {
            return FutureBuilder(
                future: getContacts(),
                builder: (BuildContext context, AsyncSnapshot<dynamic> snap) {
                  if (snap.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: Text("Loading..."),
                    );
                  } else {
                    return ChatListCardCaller(contactProfiles: contactProfiles);
                  }
                });
          }
        },
      ),
    );
  }
}

class ChatListCardCaller extends StatelessWidget {
  const ChatListCardCaller({
    Key? key,
    required this.contactProfiles,
  }) : super(key: key);

  final List contactProfiles;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
          itemCount: contactProfiles.length,
          itemBuilder: (BuildContext context, int index) {
            return ChatBar(
              contactProfiles[index]['username'],
              contactProfiles[index]['phoneNumber'],
              contactProfiles[index]['profileUrl'] ??
                  "https://chitraarasu-portfolio.herokuapp.com/assets/Passport.webp",
              "12.33 AM",
              "3",
              () {
                Get.to(
                    () => ChatScreen(
                          contactProfiles[index]['username'],
                          contactProfiles[index]['profileUrl'] ??
                              "https://chitraarasu-portfolio.herokuapp.com/assets/Passport.webp",
                          contactProfiles[index]['phoneNumber'],
                          true,
                        ),
                    transition: Transition.fadeIn);
              },
            );
          }),
    );
  }
}

class MySearchDelegate extends SearchDelegate {
  List resultContact;
  MySearchDelegate(this.resultContact);

  @override
  List<Widget> buildActions(BuildContext context) => [
        IconButton(
          icon: const Icon(
            Icons.clear,
            color: Colors.black,
          ),
          onPressed: () {
            if (query.isEmpty) {
              close(context, null);
            } else {
              query = "";
            }
          },
        )
      ];

  @override
  Widget buildLeading(BuildContext context) => IconButton(
        icon: const Icon(
          Icons.arrow_back_rounded,
          color: Colors.black,
        ),
        onPressed: () => close(context, null),
      );

  @override
  Widget buildResults(BuildContext context) => Container();

  @override
  Widget buildSuggestions(BuildContext context) {
    var listToShow;
    if (query.isNotEmpty) {
      listToShow = resultContact.where((e) {
        final title = e['username'].toLowerCase();
        final input = query.toLowerCase();
        return title.contains(input);
      }).toList();
    } else {
      listToShow = resultContact;
    }

    return ChatListCardCaller(contactProfiles: listToShow);
  }
}
