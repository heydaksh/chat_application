import 'package:chat_application/app/modules/chat/chat_controller.dart';
import 'package:chat_application/app/modules/friends/friends_controller.dart';
import 'package:chat_application/app/modules/profile/profile_controller.dart';
import 'package:get/get.dart';

import 'home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<ChatController>(() => ChatController());
    Get.lazyPut<FriendsController>(() => FriendsController());
    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}
