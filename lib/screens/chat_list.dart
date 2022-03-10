import 'package:chatting_application/widget/search.dart';
import 'package:flutter/material.dart';

class ChatList extends StatelessWidget {
  const ChatList({Key? key}) : super(key: key);

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
            child: Tab(
              icon: Image.asset(
                "assets/images/edit.png",
                width: 35,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Search(),
        ],
      ),
    );
  }
}
