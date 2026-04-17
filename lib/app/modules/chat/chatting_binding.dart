import 'package:chat_application/app/modules/chat/chatting_controller.dart';
import 'package:get/get.dart';

class ChattingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ChattingController());
  }
}
