class ApiEndpoints {
  static const String baseUrl = "https://n6grrjr8-3001.inc1.devtunnels.ms";
  // static const String testingURl = "https://plimpzik-backend-silk.vercel.app";

  // Auth Endpoints
  static const String login = "/api/auth/login";
  static const String register = "/api/auth/register";
  static const String verifyOtp = "/api/auth/verify-otp";
  static const String resendOtp = "/api/auth/resend-otp";
  static const String deleteAccount = "/api/auth/delete";
  static const String forgetPassOnLogin = "/api/auth/forgot-password";
  static const String resetPassUsingOtp = "/api/auth/reset-password";
  static const String changePassword = "/api/auth/change-password";

  // friends Endpoints
  static const String friendRequest = "/api/friend/requests";
  static const String friendAction = "/api/friend/request-action";
  static const String friendSuggestion = "/api/friend/suggestions";
  static const String sendFriendRequest = "/api/friend/send-request";
  static const String removeFriend = "/api/friend/unfriend/";

  // chat Endpoints
  static const String createChatRoom = "/api/chat/create-room";
  static const String getChatRooms = "/api/chat/rooms";

  // message Endpoints
  static const String sendMessage = "/api/message/send-message";
  //payload {
  //   "chatId": "64f1a2b3c4d5e6f7a8b9c0d1",
  //   "content": "Hello, how are you?",
  //   "messageType": "text"
  // }

  static const String getMessageList =
      "/api/message/list"; //  pass chat room id here /{id}
  static const String deleteMessage =
      "/api/message"; //  pass message id here /{id}

  // profile endpoints
  static const String getProfile =
      "/api/auth/profile"; // ( GET ) get logged in user profile details.
  static const String updateProfile =
      "/api/auth/profile-update"; // ( PATCH ) update user profile
  static const String uploadProfilePic =
      "/api/auth/profile-photo"; // ( POST ) when no profile  photo is uploaded
  static const String deleteProfilePic =
      "/api/auth/profile-photo"; // ( DELETE )
}
