import 'dart:ui';

import 'package:flutter/material.dart';

class ChatProfileSheet extends StatelessWidget {
  final name;
  final image;
  final number;

  ChatProfileSheet(this.name, this.image, this.number);
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
                SizedBox(
                  height: 75 / 2 + 40,
                ),
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  number,
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: -75 / 2 - 40,
          child: CircleAvatar(
            radius: 75,
            backgroundImage: NetworkImage(image),
          ),
        ),
      ],
    );
  }
}
