import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widget/chat_profile_sheet.dart';

class ChatScreen extends StatelessWidget {
  final name;
  final image;
  final number;
  ChatScreen(this.name, this.image, this.number);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  child: ChatProfileSheet(name, image, number),
                );
              },
            );
          },
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(image),
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                name,
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF86898f),
              ),
              child: Icon(Icons.phone),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF86898f),
              ),
              child: Icon(Icons.search),
            ),
          ),
          SizedBox(
            width: 10,
          ),
        ],
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
      ),
    );
  }
}
