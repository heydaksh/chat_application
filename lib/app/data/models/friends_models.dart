class FriendUser {
  final String? id;
  final String? friendshipId;
  final String? username;
  final String? email;
  final String? profilePic;
  final String? bio;

  FriendUser({
    this.id,
    this.friendshipId,
    this.username,
    this.email,
    this.profilePic,
    this.bio,
  });

  factory FriendUser.fromJson(Map<String, dynamic> json) {
    return FriendUser(
      id: json['_id'] ?? json['id'],
      username: json['username'],
      email: json['email'],
      profilePic: json['profilePic'] is Map
          ? (json['profilePic']['url'] ?? '')
          : (json['profilePic'] ?? ''),
      bio: json['bio'] ?? '',
    );
  }

  FriendUser copyWith({
    String? id,
    String? friendshipId,
    String? username,
    String? email,
    String? profilePic,
    String? bio,
  }) {
    return FriendUser(
      id: id ?? this.id,
      friendshipId: friendshipId ?? this.friendshipId,
      username: username ?? this.username,
      email: email ?? this.email,
      profilePic: profilePic ?? this.profilePic,
      bio: bio ?? this.bio,
    );
  }
}

class FriendRequest {
  final String requestId;
  final FriendUser? sender;
  final String? status;

  FriendRequest({required this.requestId, this.sender, this.status});

  factory FriendRequest.fromJson(Map<String, dynamic> json) {
    return FriendRequest(
      requestId: json['_id'],
      sender: json['sender'] != null
          ? (json['sender'] is String
                ? FriendUser(id: json['sender'])
                : FriendUser.fromJson(json['sender']))
          : null,
      status: json['status'],
    );
  }
}

class SuggestionResponse {
  final List<FriendUser> suggestions;

  SuggestionResponse({required this.suggestions});

  factory SuggestionResponse.fromJson(Map<String, dynamic> json) {
    var list = json['suggetions'] as List? ?? [];
    List<FriendUser> suggestionsList = list
        .map((i) => FriendUser.fromJson(i))
        .toList();
    return SuggestionResponse(suggestions: suggestionsList);
  }
}

class Friendship {
  final String? id;
  final FriendUser? sender;
  final FriendUser? receiver;
  final String? status;

  Friendship({this.id, this.sender, this.receiver, this.status});

  factory Friendship.fromJson(Map<String, dynamic> json) {
    return Friendship(
      id: json['_id'] ?? json['id'],
      sender: json['sender'] != null
          ? (json['sender'] is Map<String, dynamic>
                ? FriendUser.fromJson(json['sender'])
                : FriendUser(id: json['sender']))
          : null,
      receiver: json['receiver'] != null
          ? (json['receiver'] is Map<String, dynamic>
                ? FriendUser.fromJson(json['receiver'])
                : FriendUser(id: json['receiver']))
          : null,
      status: json['status'],
    );
  }
}

class FriendListResponse {
  final List<FriendUser> friends;

  FriendListResponse({required this.friends});

  factory FriendListResponse.fromJson(Map<String, dynamic> json) {
    var list = json['friends'] as List? ?? [];
    List<FriendUser> friendsList = list
        .map((i) => FriendUser.fromJson(i))
        .toList();
    return FriendListResponse(friends: friendsList);
  }
}
