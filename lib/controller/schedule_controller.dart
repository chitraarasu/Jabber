import 'package:chatting_application/model/schedule_mesage_model.dart';
import 'package:get/get.dart';

class SMController extends GetxController {
  final _messages = [];

  get message {
    return _messages.reversed.toList();
  }

  addMessage(message, type) {
    _messages.add(ScheduleMessageModel(message, type));
    update();
  }
}
