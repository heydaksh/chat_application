import 'package:chat_application/core/utils/app_global.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  static final SocketService _instance = SocketService._internal();

  factory SocketService() {
    return _instance;
  }

  SocketService._internal();

  IO.Socket? socket;

  void connect({required String url, required String token}) {
    AppGlobal.printLog("Attempting to connect to socket at: $url");

    socket = IO.io(
      url,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableAutoConnect()
          .setAuth({'token': token})
          .build(),
    );

    socket!.connect();

    socket!.onConnect((_) {
      AppGlobal.printLog("✅ Socket Connected: ${socket!.id}");
    });

    socket!.on("force_logout", (data) {
      AppGlobal.printLog("log out forced $data");
    });

    socket!.onDisconnect((_) {
      AppGlobal.printLog("❌ Socket Disconnected");
    });

    socket!.onConnectError((data) {
      AppGlobal.printLog("⚠️ Socket Connection Error: $data");
    });
  }

  /// CLIENT-TO-SERVER EVENTS

  // Join a specific chat room
  void joinChat(String chatId) {
    AppGlobal.printLog("🏠 Joining Chat Room: $chatId");
    socket?.emit("join_chat", chatId);
  }

  // Leave a chat room
  void leaveChat(String chatId) {
    AppGlobal.printLog("🚪 Leaving Chat Room: $chatId");
    socket?.emit("leave_chat", chatId);
  }

  // Mark messages as read
  void markRead(String chatId) {
    socket?.emit("mark_read", chatId);
  }

  // Notify others you are typing
  void typing(String chatId) {
    AppGlobal.printLog('typing started');
    socket?.emit("typing", chatId);
  }

  // Notify others you stopped typing
  void stopTyping(String chatId) {
    AppGlobal.printLog('typing stopped');

    socket?.emit("stop_typing", chatId);
  }

  void disconnect() {
    AppGlobal.printLog("🔌 Manually disconnecting socket");
    socket?.disconnect();
  }

  bool get isConnected => socket?.connected ?? false;
}
