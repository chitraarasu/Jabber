import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';

import '../widget/chat_profile_sheet.dart';

class ChatScreen extends StatelessWidget {
  final name;
  final image;
  final number;
  final isFromContact;
  ChatScreen(this.name, this.image, this.number, this.isFromContact);

  @override
  Widget build(BuildContext context) {
    List<Message> messages = [
      Message(
        "Hi",
        DateTime.now().subtract(const Duration(minutes: 1)),
        false,
      ),
      Message(
        "hello",
        DateTime.now().subtract(const Duration(minutes: 1)),
        true,
      ),
      Message(
        "How r u?",
        DateTime.now().subtract(const Duration(minutes: 1)),
        false,
      ),
      Message(
        "good",
        DateTime.now().subtract(const Duration(minutes: 1, days: 1)),
        true,
      ),
      Message(
        "what about u?",
        DateTime.now().subtract(const Duration(minutes: 1, days: 2)),
        false,
      ),
      Message(
        "hmm, good",
        DateTime.now().subtract(const Duration(minutes: 1)),
        true,
      ),
      Message(
        "Its been so long",
        DateTime.now().subtract(const Duration(minutes: 1)),
        true,
      ),
      Message(
        "Lorem ipsum",
        DateTime.now().subtract(const Duration(minutes: 1, days: 2)),
        false,
      ),
      Message(
        "Lorem ipsum",
        DateTime.now().subtract(const Duration(minutes: 1, days: 2)),
        true,
      ),
      Message(
        "Lorem ipsum",
        DateTime.now().subtract(const Duration(minutes: 1, days: 2)),
        false,
      ),
      Message(
        "Lorem ipsum",
        DateTime.now().subtract(const Duration(minutes: 1, days: 2)),
        true,
      ),
      Message(
        "Lorem ipsum",
        DateTime.now().subtract(const Duration(minutes: 1, days: 2)),
        false,
      ),
      Message(
        "Lorem ipsum",
        DateTime.now().subtract(const Duration(minutes: 1, days: 2)),
        true,
      ),
    ];

    Future<bool> _onWillPop() async {
      Get.back();
      isFromContact ? Get.back() : null;
      return false;
    }

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
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
              isFromContact ? Get.back() : null;
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
                Hero(
                  tag: name,
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(image),
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
            IconButton(
              onPressed: () {},
              icon: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF86898f),
                ),
                child: const Icon(Icons.phone),
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF86898f),
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
        ),
        body: Column(
          children: [
            Expanded(
              child: GroupedListView<Message, DateTime>(
                reverse: true,
                order: GroupedListOrder.DESC,
                useStickyGroupSeparators: true,
                floatingHeader: true,
                padding: const EdgeInsets.all(8),
                elements: messages,
                groupBy: (message) => DateTime(
                  message.date.year,
                  message.date.month,
                  message.date.day,
                ),
                groupHeaderBuilder: (Message message) => SizedBox(
                  height: 40,
                  child: Center(
                    child: Card(
                      color: Colors.lightBlueAccent,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          DateFormat.yMMMd().format(message.date),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
                itemBuilder: (context, Message message) => Align(
                  alignment: message.isSendByMe
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Card(
                    elevation: 8,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(message.text),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              color: Colors.grey.shade300,
              child: TextField(
                onSubmitted: (text) {
                  final message = Message(text, DateTime.now(), true);
                  messages.add(message);
                },
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(12),
                  hintText: "Type your message here",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Message {
  final text;
  final date;
  final isSendByMe;

  Message(this.text, this.date, this.isSendByMe);
}
