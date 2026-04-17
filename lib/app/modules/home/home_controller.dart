import 'package:chat_application/app/routes/app_routes.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  var drawerValue = 0.0.obs;
  var currentTab = 0.obs;

  void toggleDrawer() {
    drawerValue.value = drawerValue.value == 0 ? 1 : 0;
  }

  void changeTab(int index) {
    currentTab.value = index;
  }

  void goToChat() => Get.toNamed(Routes.chat);
  void goToProfile() => Get.toNamed(Routes.profile);
}
