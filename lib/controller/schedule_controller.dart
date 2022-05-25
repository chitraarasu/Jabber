import 'dart:convert';

import 'package:chatting_application/model/schedule_mesage_model.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

import '../model/notification.dart';

class SMController extends GetxController {
  final _messages = [];

  get message {
    return _messages.reversed.toList();
  }

  addMessage(message, type) {
    _messages.add(ScheduleMessageModel(message, type));
    update();
  }

  makeSchedule(channelId, DateTime date, TimeOfDay time) async {
    final user = FirebaseAuth.instance.currentUser!;
    var data = {
      'currentUserId': user.uid,
      'cid': channelId,
      'messages': _messages.map((item) => "${item.message}").toList(),
      'type': _messages.map((item) => "${item.type}").toList()
    };
    final scheduleTime =
        DateTime(date.year, date.month, date.day, time.hour, time.minute);
    final now = DateTime.now();
    final difference = scheduleTime.difference(now).inSeconds;
    print(difference);
    Workmanager().cancelByTag('$channelId');
    Workmanager().registerOneOffTask("$channelId", "simpleTask",
        inputData: data,
        initialDelay: Duration(seconds: difference),
        constraints: Constraints(networkType: NetworkType.connected));
    Get.back();
  }
}
