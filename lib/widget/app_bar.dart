import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'chat_profile_sheet.dart';

class CustomAppBar extends StatelessWidget {
  final image;
  final name;
  final channelId;

  CustomAppBar(this.name, this.image, this.channelId);

  @override
  Widget build(BuildContext context) {
    return AppBar(
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
    );
  }
}
