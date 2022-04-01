import 'dart:io';

import 'package:chatting_application/screens/calls.dart';
import 'package:chatting_application/screens/chat_list.dart';
import 'package:chatting_application/screens/create_new_channel_or_join_channel.dart';
import 'package:chatting_application/screens/settings.dart';
import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:get/get.dart';

import '../screens/chat_bot.dart';

class Controller extends GetxController {
  var _index = 0;

  var _isLoading = false;

  get isLoading {
    return _isLoading;
  }

  setIsLoading(val) {
    _isLoading = val;
  }

  final _screens = [
    ChatList(),
    const Calls(),
    const ChatBot(),
    const Settings(),
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

  get selectedDialogCountry {
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
}
