import 'dart:ui';

import 'package:flutter/material.dart';

class ChatProfileSheet extends StatelessWidget {
  final name;
  final image;

  ChatProfileSheet(this.name, this.image);
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40.0),
              topRight: Radius.circular(40.0),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 75 / 2 + 40,
                ),
                Text(
                  name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // Text(
                //   number,
                // ),
              ],
            ),
          ),
        ),
        Positioned(
          top: -75 / 2 - 40,
          child: CircleAvatar(
            backgroundColor: const Color(0xFFd6e2ea),
            radius: 75,
            backgroundImage: image == null ? null : NetworkImage(image),
            child: image == null
                ? const Icon(
                    Icons.person_rounded,
                    color: Colors.grey,
                    size: 100,
                  )
                : null,
          ),
        ),
      ],
    );
  }
}
