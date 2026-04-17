import 'package:chat_application/app/modules/auth/signup/username/username_controller.dart';
import 'package:get/get.dart';

class UsernameBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UsernameController>(() => UsernameController());
  }
}
