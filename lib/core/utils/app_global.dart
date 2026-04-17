import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppGlobal {
  static final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  /// Custom logger required by project rules.
  /// Usage: AppGlobal.printLog("Context: Action happened - Variable: $var");
  static void printLog(String message) {
    if (kDebugMode) {
      debugPrint("🚀 [APP LOG]: $message");
    }
  }
}
