import 'dart:ui';

import 'package:chatting_application/controller/schedule_controller.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../widget/message_bubble.dart';

class ScheduleMessage extends StatefulWidget {
  final channelId;
  ScheduleMessage(this.channelId);
  @override
  State<ScheduleMessage> createState() => _ScheduleMessageState();
}

class _ScheduleMessageState extends State<ScheduleMessage> {
  TimeOfDay? selectedTime;
  FocusNode focusNode = FocusNode();
  var isEmojiVisible = false.obs;
  var _enteredMessage = ''.obs;
  TextEditingController _controller = TextEditingController();

  Future _selectTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      selectedTime = pickedTime;
      setState(() {});
    }
  }

  DateTime? selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(
        Duration(days: 360),
      ),
    );
    if (picked != null) {
      selectedDate = picked;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (isEmojiVisible.value) {
          isEmojiVisible.value = false;
        } else {
          Navigator.pop(context);
        }
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: Colors.black,
            ),
            onPressed: () {
              Get.back();
            },
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            "Schedule Message",
            style: TextStyle(
              color: Colors.black,
              letterSpacing: 1,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () async {
                if (selectedDate == null || selectedTime == null) {
                  Fluttertoast.showToast(
                    msg: "Please select date and time.",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                } else if (Get.find<SMController>().message.length == 0) {
                  Fluttertoast.showToast(
                    msg: "Please add the message.",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                } else {
                  Get.find<SMController>().makeSchedule(
                      widget.channelId, selectedDate!, selectedTime!);
                }
              },
              icon: const Icon(
                Icons.done_rounded,
                color: Colors.blue,
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Row(
                children: [
                  CustomCardForTime(
                      selectedDate == null
                          ? 'DD/MM/YYYY'
                          : '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',
                      () {
                    _selectDate(context);
                  }, 'assets/animations/calender.json'),
                  CustomCardForTime(
                      selectedTime == null
                          ? 'HH/MM'
                          : '${selectedTime!.hour}:${selectedTime!.minute} ${selectedTime!.periodOffset == 0 ? 'AM' : 'PM'}',
                      () {
                    _selectTime();
                  }, 'assets/animations/clock.json'),
                ],
              ),
              const Center(
                child: Text("You can schedule once per channel."),
              ),
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: GetBuilder<SMController>(
                        init: SMController(),
                        builder: (getController) => ListView.builder(
                          reverse: true,
                          itemCount: getController.message.length,
                          itemBuilder: (ctx, index) {
                            if (getController.message[index].type == "text") {
                              return MessageBubble(
                                getController.message[index].message,
                                true,
                                '',
                                '',
                              );
                            } else {
                              return ImageBubble(
                                getController.message[index].message,
                                true,
                                '',
                                '',
                              );
                            }
                          },
                        ),
                      ),
                      // child: Container(),
                    ),
                    Container(
                      color: Colors.white,
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 8.0, left: 8.0, bottom: 8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFFf7f7f7),
                                  border: Border.all(
                                    width: 1,
                                    color: Colors.grey,
                                  ),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(25.0),
                                  ),
                                ),
                                child: SizedBox(
                                  height: 45.0,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      FloatingActionButton.small(
                                        heroTag: const Text("btn1"),
                                        elevation: 0,
                                        disabledElevation: 0,
                                        hoverElevation: 0,
                                        highlightElevation: 0,
                                        focusElevation: 0,
                                        onPressed: () {
                                          isEmojiVisible.value =
                                              !isEmojiVisible.value;
                                          focusNode.unfocus();
                                          focusNode.canRequestFocus = true;
                                        },
                                        backgroundColor: Colors.transparent,
                                        child: const Icon(
                                          Icons.insert_emoticon,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Expanded(
                                        child: TextField(
                                          textCapitalization:
                                              TextCapitalization.sentences,
                                          controller: _controller,
                                          focusNode: focusNode,
                                          minLines: 1,
                                          maxLines: 5,
                                          keyboardType: TextInputType.multiline,
                                          textInputAction:
                                              TextInputAction.newline,
                                          onChanged: (value) {
                                            _enteredMessage.value = value;
                                          },
                                          decoration: const InputDecoration(
                                            hintText: "Schedule message",
                                            hintStyle:
                                                TextStyle(color: Colors.grey),
                                            border: InputBorder.none,
                                          ),
                                        ),
                                      ),
                                      FloatingActionButton.small(
                                        heroTag: const Text("btn2"),
                                        elevation: 0,
                                        disabledElevation: 0,
                                        hoverElevation: 0,
                                        highlightElevation: 0,
                                        focusElevation: 0,
                                        onPressed: () async {
                                          FilePickerResult? result =
                                              await FilePicker.platform
                                                  .pickFiles(
                                                      // allowMultiple: true,
                                                      type: FileType.image);
                                          if (result != null) {
                                            // Get.to(
                                            //         () => CustomImageView(
                                            //         result.files.first,
                                            //         widget.channelId),
                                            //     transition: Transition.zoom);
                                          }
                                        },
                                        backgroundColor: Colors.transparent,
                                        child: const Icon(
                                          Icons.link_outlined,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Obx(
                            () => FloatingActionButton.small(
                              heroTag: const Text("btn3"),
                              elevation: 0,
                              disabledElevation: 0,
                              hoverElevation: 0,
                              highlightElevation: 0,
                              focusElevation: 0,
                              onPressed: _enteredMessage.trim().isEmpty
                                  ? null
                                  : () {
                                      Get.find<SMController>().addMessage(
                                          _enteredMessage.value, "text");
                                      _controller.clear();
                                      _enteredMessage.value = '';
                                      FocusScope.of(context).unfocus();
                                    },
                              backgroundColor: Colors.deepOrange,
                              child: const Icon(
                                Icons.send_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Obx(
                      () => Offstage(
                        offstage: !isEmojiVisible.value,
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * .2,
                          child: EmojiPicker(
                            onEmojiSelected: (category, emoji) {
                              _controller.text = _controller.text + emoji.emoji;
                              _enteredMessage.value =
                                  _controller.text + emoji.emoji;
                            },
                            onBackspacePressed: () {},
                            config: const Config(
                                columns: 7,
                                verticalSpacing: 0,
                                horizontalSpacing: 0,
                                initCategory: Category.SMILEYS,
                                bgColor: Color(0xFFF2F2F2),
                                indicatorColor: Colors.blue,
                                iconColor: Colors.grey,
                                iconColorSelected: Colors.blue,
                                // progressIndicatorColor: Colors.blue,
                                // showRecentsTab: true,
                                recentsLimit: 28,
                                // noRecentsText: "No Recents",
                                // noRecentsStyle: TextStyle(
                                //     fontSize: 20, color: Colors.black26),
                                tabIndicatorAnimDuration: kTabScrollDuration,
                                categoryIcons: CategoryIcons(),
                                buttonMode: ButtonMode.MATERIAL),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomCardForTime extends StatelessWidget {
  final value;
  final onTap;
  final path;
  CustomCardForTime(this.value, this.onTap, this.path);
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          onTap();
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.white,
          ),
          margin: const EdgeInsets.all(5.0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset(
                    path,
                    width: 300,
                    height: MediaQuery.of(context).size.height * .15,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    value,
                    style: TextStyle(fontSize: 15),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
