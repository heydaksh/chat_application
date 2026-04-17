import 'package:chat_application/app/modules/auth/forget_password/forget_password.dart';
import 'package:chat_application/app/modules/auth/forget_password/set_new_password_screen.dart';
import 'package:chat_application/app/modules/auth/otp/otp_binding.dart';
import 'package:chat_application/app/modules/auth/otp/otp_screen.dart';
import 'package:chat_application/app/modules/auth/signup/username/username_binding.dart';
import 'package:chat_application/app/modules/auth/signup/username/username_screen.dart';
import 'package:chat_application/app/modules/chat/chat_binding.dart';
import 'package:get/get.dart';

import '../modules/auth/login/login_binding.dart';
import '../modules/auth/login/login_screen.dart';
import '../modules/auth/signup/signup_binding.dart';
import '../modules/auth/signup/signup_screen.dart';
import '../modules/chat/chat_module.dart';
import '../modules/chat/chatting_screen.dart';
import '../modules/chat/chatting_binding.dart';
import '../modules/friends/my_friends_screen.dart';
import '../modules/home/home_binding.dart';
import '../modules/home/home_screen.dart';
import '../modules/profile/profile_screen.dart';
import 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.login;

  static final routes = [
    GetPage(
      name: Routes.login,
      page: () => LoginScreen(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: Routes.username,
      page: () => UsernameScreen(),
      binding: UsernameBinding(),
    ),
    GetPage(name: Routes.forgetPass, page: () => ForgetPassword()),
    GetPage(
      name: Routes.signup,
      page: () => SignupScreen(),
      binding: SignupBinding(),
    ),
    GetPage(name: Routes.otp, page: () => OtpScreen(), binding: OtpBinding()),
    GetPage(
      name: Routes.home,
      page: () => const HomeScreen(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.chat,
      page: () => const ChatScreen(),
      binding: ChatBinding(),
    ),
    GetPage(
      name: Routes.profile,
      page: () => ProfileScreen(),
      binding: ProfileBinding(),
    ),
    GetPage(name: Routes.myFriends, page: () => const MyFriendsScreen()),
    GetPage(name: Routes.setNewPassword, page: () => SetNewPasswordScreen()),
    GetPage(
      name: Routes.messageScreen,
      page: () => const ChattingScreen(),
      binding: ChattingBinding(),
    ),
  ];
}
