import 'package:chatting_application/widget/open_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class MessageBubble extends StatelessWidget {
  final message;
  final isMe;
  final username;
  final time;
  MessageBubble(this.message, this.isMe, this.username, this.time);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width * 0.65;
    return GestureDetector(
      onLongPress: () {
        Clipboard.setData(ClipboardData(text: message));
        Fluttertoast.showToast(
          msg: "Message copied!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      },
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          IntrinsicWidth(
            child: Container(
              constraints: BoxConstraints(maxWidth: screenWidth),
              decoration: BoxDecoration(
                color: isMe ? const Color(0xFFf1f7ff) : const Color(0xFFf8f8f7),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: !isMe
                      ? const Radius.circular(0)
                      : const Radius.circular(20),
                  bottomRight: isMe
                      ? const Radius.circular(0)
                      : const Radius.circular(20),
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
                        time,
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
      ),
    );
  }
}

class ImageBubble extends StatelessWidget {
  final url;
  final isMe;
  final username;
  final time;
  ImageBubble(this.url, this.isMe, this.username, this.time);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width * 0.65;
    return GestureDetector(
      onTap: () {
        Get.to(() => OpenImage(url), transition: Transition.noTransition);
      },
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          IntrinsicWidth(
            child: Container(
              constraints: BoxConstraints(maxWidth: screenWidth),
              decoration: BoxDecoration(
                color: isMe ? const Color(0xFFf1f7ff) : const Color(0xFFf8f8f7),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: !isMe
                      ? const Radius.circular(0)
                      : const Radius.circular(20),
                  bottomRight: isMe
                      ? const Radius.circular(0)
                      : const Radius.circular(20),
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
                          crossAxisAlignment: isMe
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
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
                            Container(
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Hero(
                                tag: url,
                                child: Image(
                                  image: NetworkImage(url),
                                  height: 200,
                                  width: MediaQuery.of(context).size.width * .4,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                time,
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
