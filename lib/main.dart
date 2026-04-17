import 'package:chat_application/app/routes/app_pages.dart';
import 'package:chat_application/app/routes/app_routes.dart';
import 'package:chat_application/app/services/auth_service.dart';
import 'package:chat_application/core/theme/app_theme.dart';
import 'package:chat_application/core/utils/app_global.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
    AppGlobal.printLog('FireBase logged in');
  } catch (e) {
    AppGlobal.printLog("Firebase Initialization Error: $e");
  }

  // Initialize Auth Service
  final authService = await Get.putAsync(() => AuthService().init());

  // Determine initial route
  final String initialRoute = authService.isLoggedIn
      ? Routes.home
      : AppPages.INITIAL;

  runApp(MyApp(initialRoute: initialRoute));
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      scaffoldMessengerKey: AppGlobal.scaffoldMessengerKey,
      debugShowCheckedModeBanner: false,
      title: 'Chat Application',
      theme: AppTheme.lightTheme,
      initialRoute: initialRoute,
      getPages: AppPages.routes,
    );
  }
}
