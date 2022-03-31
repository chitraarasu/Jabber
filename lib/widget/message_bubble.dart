import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final message;
  final isMe;
  final username;
  MessageBubble(this.message, this.isMe, this.username);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: isMe ? const Color(0xFFf1f7ff) : const Color(0xFFf8f8f7),
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(20),
              topRight: const Radius.circular(20),
              bottomLeft:
                  !isMe ? const Radius.circular(0) : const Radius.circular(20),
              bottomRight:
                  isMe ? const Radius.circular(0) : const Radius.circular(20),
            ),
          ),
          padding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 16,
          ),
          margin: const EdgeInsets.symmetric(
            vertical: 14,
            horizontal: 8,
          ),
          child: Column(
            crossAxisAlignment:
                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              // Text(
              //   '$username',
              //   style: TextStyle(
              //     color: isMe ? Colors.pink : Colors.grey,
              //     fontWeight: FontWeight.bold,
              //     fontSize: 15.0,
              //   ),
              // ),
              Row(
                children: [
                  Text(
                    message,
                    style: TextStyle(
                      color: isMe ? const Color(0xFF3587ff) : Colors.grey[700],
                      fontSize: 18.5,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      "10 am",
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
