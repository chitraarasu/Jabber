import 'dart:convert';
import 'dart:io';

import 'package:chatting_application/screens/dashboard/music.dart';
import 'package:chatting_application/screens/dashboard/chat_list.dart';
import 'package:chatting_application/screens/create_new_channel_or_join_channel.dart';
import 'package:chatting_application/screens/dashboard/profile.dart';
import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:get/get.dart';

import '../screens/chats/chat_bot.dart';
import '../screens/dashboard/news.dart';
import 'package:http/http.dart' as http;

class HomeController extends GetxController {
  var _index = 0;
  var isEmojiVisible = false;

  var _isLoading = false;

  get isLoading {
    return _isLoading;
  }

  setIsLoading(val) {
    _isLoading = val;
  }

  var _value = 0;

  get value {
    return _value;
  }

  setValue(val) {
    _value = val;
    update();
  }

  final _screens = [
    ChatList(),
    Music(),
    News(),
    Profile(),
  ];

  get body {
    return _screens[_index];
  }

  get index {
    return _index;
  }

  setScreen(index) {
    switch (index) {
      case 0:
        _index = index;
        break;
      case 1:
        _index = index;
        break;
      case 2:
        _index = index;
        break;
      case 3:
        _index = index;
        break;
    }
    update();
  }

  Country _selectedDialogCountry =
      CountryPickerUtils.getCountryByPhoneCode('91');

  Country get selectedDialogCountry {
    return _selectedDialogCountry;
  }

  setCountry(country) {
    _selectedDialogCountry = country;
    update();
  }

  File? _storedImage;
  File? _storedChannelImage;

  get userProfileImage {
    return _storedImage;
  }

  get channelProfileImage {
    return _storedChannelImage;
  }

  setUserProfileImage(image) {
    _storedImage = image;
    update();
  }

  setChannelProfileImage(image) {
    _storedChannelImage = image;
    update();
  }

  sendNotification({data, token, name, message}) async {
    const url = 'https://fcm.googleapis.com/fcm/send';
    const serverKey =
        'AAAAoA33ArQ:APA91bFMBlRp7CZYp1uIrLdSmLcXqenmqDJsgEt7WHL8Wer4EuUHwfyo93FhNPjOTcXTyUTdXX7IbUSGy3XqVjjkUcbHsXsz2Ak13cWtPcvD2Cam2CBaUIcvtVaOme95aHK3emKenKny';

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'key=$serverKey',
    };

    final messagee = {
      'to': token,
      'data': data,
      'notification': {
        "body": message,
        "title": name,
      },
      'priority': 'high',
    };

    print(messagee);

    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(messagee),
    );

    if (response.statusCode == 200) {
      print('Notification sent successfully');
    } else {
      print('Failed to send notification. Error: ${response.body}');
    }
  }
}
