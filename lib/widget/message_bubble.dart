import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final message;
  final isMe;
  final username;
  MessageBubble(this.message, this.isMe, this.username);

  @override
  Widget build(BuildContext context) {
    double screen_width = MediaQuery.of(context).size.width * 0.65;
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        IntrinsicWidth(
          child: Container(
            constraints: BoxConstraints(maxWidth: screen_width),
            decoration: BoxDecoration(
              color: isMe ? const Color(0xFFf1f7ff) : const Color(0xFFf8f8f7),
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(20),
                topRight: const Radius.circular(20),
                bottomLeft: !isMe
                    ? const Radius.circular(0)
                    : const Radius.circular(20),
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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (!isMe)
                            Text(
                              username,
                              style: TextStyle(
                                color: isMe
                                    ? const Color(0xFF3587ff)
                                    : Colors.grey[700],
                              ),
                            ),
                          if (!isMe)
                            const SizedBox(
                              height: 5,
                            ),
                          Text(
                            message,
                            style: TextStyle(
                              color: isMe
                                  ? const Color(0xFF3587ff)
                                  : Colors.grey[700],
                              fontSize: 18.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      "10 am",
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
