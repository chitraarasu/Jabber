import 'dart:convert';

import 'package:chatting_application/model/schedule_mesage_model.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

import '../model/notification.dart';

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    print("Native called background task: $task");
    // final prefs = await SharedPreferences.getInstance();
    // print(prefs.getString('sd'));
    // var connectivityResult = await (Connectivity().checkConnectivity());
    // print(connectivityResult);
    // if (connectivityResult == ConnectivityResult.none) {
    //   NotificationApi.showNotification(
    //     title: 'None',
    //     body: 'Working bad',
    //     payload: 'Working bad',
    //   );
    // } else {
    //   NotificationApi.showNotification(
    //     title: 'Done',
    //     body: 'Working good',
    //     payload: 'Working fine',
    //   );
    // }
    return Future.value(true);
  });
}

class SMController extends GetxController {
  final _messages = [];

  get message {
    return _messages.reversed.toList();
  }

  addMessage(message, type) {
    _messages.add(ScheduleMessageModel(message, type));
    update();
  }

  // ScheduledList(channelId) async {
  //   final prefs = await SharedPreferences.getInstance();
  //
  // var prevItems = prefs.getStringList('scheduledList');

  // if (prevItems != null && !prevItems.contains(channelId)) {
  //   prefs.setStringList('scheduledList', [
  //     ...prevItems,
  //     channelId,
  //   ]);
  // } else if (prevItems == null) {
  //   prefs.setStringList('scheduledList', [
  //     channelId,
  //   ]);
  // }
  // }

  makeSchedule(channelId, date, time) async {
    final prefs = await SharedPreferences.getInstance();
    var data = {
      'cid': channelId,
      'messages': _messages.map((item) => item.message).toList(),
      'type': _messages.map((item) => item.type).toList()
    };
    prefs.setString('sd', jsonEncode(data));
    print(prefs.getString('sd'));
    Workmanager().registerPeriodicTask("2", "simplePeriodicTask",
        frequency: Duration(minutes: 15));
  }
}
