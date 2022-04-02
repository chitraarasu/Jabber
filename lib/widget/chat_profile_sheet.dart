import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
                    color: Colors.deepOrange,
                  ),
                ),
                const SizedBox(
                  height: 10,
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
