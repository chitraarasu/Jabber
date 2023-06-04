import 'package:chatting_application/controller/schedule_controller.dart';
import 'package:get/get.dart';
import 'controller.dart';

class Binder extends Bindings {
  @override
  void dependencies() {
    Get.put(HomeController());
    Get.put(SMController());
  }
}
