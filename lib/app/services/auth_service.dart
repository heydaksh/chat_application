import 'package:chat_application/app/services/api_services/api_endpoints.dart';
import 'package:chat_application/core/utils/app_global.dart';
import 'package:chat_application/core/widgets/sockets/socket_service.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService extends GetxService {
  static AuthService get to => Get.find();

  late SharedPreferences _prefs;
  final _isLoggedIn = false.obs;
  final _token = RxnString();
  final _userId = RxnString();

  bool get isLoggedIn => _isLoggedIn.value;
  String? get token => _token.value;
  String? get userId => _userId.value;

  Future<AuthService> init() async {
    AppGlobal.printLog("[AUTH SERVICE] Initializing...");
    _prefs = await SharedPreferences.getInstance();

    _token.value = _prefs.getString('auth_token');
    _userId.value = _prefs.getString('user_id');
    _isLoggedIn.value = _token.value != null;

    if (_isLoggedIn.value && _token.value != null) {
      _connectSocket(_token.value!);
    }

    AppGlobal.printLog("[AUTH SERVICE] Logged in: ${_isLoggedIn.value}");
    return this;
  }

  Future<void> saveToken(String token) async {
    await _prefs.setString('auth_token', token);
    _token.value = token;
    _isLoggedIn.value = true;
    _connectSocket(token);
  }

  void _connectSocket(String token) {
    SocketService().connect(
      url: ApiEndpoints.baseUrl,
      token: token,
    );
  }

  void _disconnectSocket() {
    SocketService().disconnect();
  }

  Future<void> saveUserId(String id) async {
    await _prefs.setString('user_id', id);
    _userId.value = id;
  }

  Future<void> clearAuth() async {
    await _prefs.remove('auth_token');
    await _prefs.remove('user_id');
    _token.value = null;
    _userId.value = null;
    _isLoggedIn.value = false;
    _disconnectSocket();
    AppGlobal.printLog("[AUTH SERVICE] Auth cleared.");
  }
}
