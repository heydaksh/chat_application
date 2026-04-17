class ApiResponse<T> {
  final bool success;
  final String message;
  final T? data;

  ApiResponse({required this.success, required this.message, this.data});

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromJsonT,
  ) {
    return ApiResponse<T>(
      success: json['success'] ?? false,
      message: json['message'] ?? "",
      data: json['data'] != null ? fromJsonT(json['data']) : null,
    );
  }
}

class User {
  final String? id;
  final String? username;
  final String? email;
  final String? mobile;
  final bool isVerified;
  final String? profilePic;
  final String? gender;
  final String? bio;

  User({
    this.id,
    this.username,
    this.email,
    this.isVerified = false,
    this.profilePic,
    this.gender,
    this.mobile,
    this.bio,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? json['id'],
      username: json['username'],
      email: json['email'],
      isVerified: json['isVerified'] ?? false,
      profilePic: json['profilePic'] is Map
          ? (json['profilePic']['url'] ?? '')
          : json['profilePic'],
      gender: json['gender'],
      bio: json['bio'],
      mobile: json['mobile'],
    );
  }
}

class AuthResponse {
  final User? user;
  final String? token;

  AuthResponse({this.user, this.token});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      token: json['token'],
    );
  }
}
