import 'dart:ui';

import 'package:chatting_application/screens/map.dart';
import 'package:chatting_application/screens/user_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ChatProfileSheet extends StatelessWidget {
  final name;
  final image;
  final channelId;

  ChatProfileSheet(this.name, this.image, this.channelId);
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
                    color: Colors.orange,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CustomCircleButton(
                      Icons.list_alt_rounded,
                      Colors.blue,
                      const Color(0xFFebf4ff),
                      () {
                        Get.to(
                          () => ChannelUserList(
                            channelId: channelId,
                          ),
                          transition: Transition.noTransition,
                        );
                      },
                    ),
                    CustomCircleButton(
                      Icons.location_on,
                      Colors.pinkAccent,
                      const Color(0xFFf9edff),
                      () {
                        Get.to(
                          () => Map(channelId),
                          transition: Transition.noTransition,
                        );
                      },
                    ),
                    CustomCircleButton(
                      Icons.edit,
                      Colors.purple,
                      const Color(0xFFffebf8),
                      () {},
                    ),
                    CustomCircleButton(
                      Icons.exit_to_app,
                      Colors.orange,
                      const Color(0xFFfff1eb),
                      () {},
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                const Text(
                  "Invite id",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SelectableText(
                      channelId,
                      cursorColor: const Color(0xFF006aff),
                      showCursor: true,
                      toolbarOptions: const ToolbarOptions(
                        copy: true,
                        selectAll: true,
                        cut: false,
                        paste: false,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: channelId));
                      },
                      icon: const Icon(
                        Icons.copy,
                        size: 20,
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 4),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: QrImage(
                    data: channelId,
                    version: QrVersions.auto,
                    size: 150.0,
                  ),
                ),
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

class CustomCircleButton extends StatelessWidget {
  final icon;
  final color;
  final bgColor;
  final onTap;

  CustomCircleButton(this.icon, this.color, this.bgColor, this.onTap);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: CircleAvatar(
        child: Icon(
          icon,
          color: color,
        ),
        backgroundColor: bgColor,
      ),
    );
  }
}
