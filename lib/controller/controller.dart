import 'dart:convert';
import 'dart:io';

import 'package:chatting_application/credentials.dart';
import 'package:chatting_application/screens/dashboard/music.dart';
import 'package:chatting_application/screens/dashboard/chat_list.dart';
import 'package:chatting_application/screens/create_new_channel_or_join_channel.dart';
import 'package:chatting_application/screens/dashboard/profile.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_version_plus/new_version_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

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

  List _contactPhoneNumbers = [];

  Future getContacts() async {
    if (_contactPhoneNumbers.isNotEmpty) {
      return _contactPhoneNumbers;
    }
    PermissionStatus status = await Permission.contacts.request();
    if (status.isGranted) {
      List<Contact> contact = await ContactsService.getContacts();
      _contactPhoneNumbers = [];
      for (Contact item in contact) {
        if (item.phones == null) continue;
        if (item.phones!.isNotEmpty) {
          if (item.phones!.first.value == null) continue;
          _contactPhoneNumbers.add(
            item.phones!.first.value!.replaceAll(" ", '').replaceAll("-", ''),
          );
        }
      }
      return _contactPhoneNumbers;
    } else {
      throw "Please provide contact permission!";
    }
  }

  sendNotification({data, tokens, name, message}) async {
    const url = 'https://fcm.googleapis.com/fcm/send';

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'key=$firebaseSecret',
    };

    final messagee = {
      'registration_ids': tokens,
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

  void checkVersion(context) async {
    final newVersion = NewVersionPlus(
      iOSId: 'com.csp.jabber',
      androidId: "com.csp.jabber",
    );

    final VersionStatus? versionStatus = await newVersion.getVersionStatus();
    if (versionStatus != null && versionStatus.canUpdate) {
      showCustomDialog(versionStatus, context);
    }
  }

  showCustomDialog(VersionStatus versionStatus, context) {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Update Available"),
        content: Text(
          'You can now update this app from ${versionStatus.localVersion} to ${versionStatus.storeVersion}',
        ),
        actions: <Widget>[
          for (int i = 1; i <= 2; i++)
            TextButton(
              child: Text(
                i == 2 ? 'Maybe Later' : 'Update',
              ),
              onPressed: () {
                if (i == 2) {
                  Navigator.pop(context);
                } else {
                  launchUrl(Uri.parse(versionStatus.appStoreLink));
                }
              },
            ),
        ],
      ),
    );
  }
}
