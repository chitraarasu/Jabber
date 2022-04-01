import 'package:flutter/material.dart';

class ChatBar extends StatelessWidget {
  final id;
  final name;
  final lastMessage;
  final image;
  final time;
  final notify;
  Function onTap;

  ChatBar(
    this.id,
    this.name,
    this.lastMessage,
    this.image,
    this.time,
    this.notify,
    this.onTap,
  );
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Padding(
        padding: const EdgeInsets.only(
          top: 10,
          left: 8,
          right: 8,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Hero(
                        tag: name,
                        child: CircleAvatar(
                          radius: 25,
                          backgroundColor: const Color(0xFFd6e2ea),
                          backgroundImage:
                              image == null ? null : NetworkImage(image),
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
                        width: 20,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              lastMessage,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            time,
                            style: const TextStyle(
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFF006aff),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(notify),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(
              height: 20,
              thickness: 1,
            ),
          ],
        ),
      ),
    );
  }
}
