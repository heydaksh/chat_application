import 'package:chat_application/app/data/models/friends_models.dart';

class ChatRoom {
  final String id;
  final List<FriendUser> participants;
  final Message? lastMessage;
  final String? createdAt;
  final String? updatedAt;

  ChatRoom({
    required this.id,
    required this.participants,
    this.lastMessage,
    this.createdAt,
    this.updatedAt,
  });

  factory ChatRoom.fromJson(Map<String, dynamic> json) {
    var participantsList = json['participants'] as List? ?? [];
    List<FriendUser> parsedParticipants = [];

    for (var p in participantsList) {
      if (p is Map<String, dynamic>) {
        parsedParticipants.add(FriendUser.fromJson(p));
      } else if (p is String) {
        parsedParticipants.add(FriendUser(id: p));
      }
    }

    Message? parsedLastmessage;
    if (json['lastMessage'] != null) {
      if (json['lastMessage'] is Map<String, dynamic>) {
        parsedLastmessage = Message.fromJson(json['lastMessage']);
      } else if (json['lastMessage'] is String) {
        parsedLastmessage = Message(
          id: json['lastMessage'],
          chatId: json['_id'] ?? json['id'] ?? '',
          content: 'Tap to open conversation.',
          messageType: 'text',
        );
      }
    }

    return ChatRoom(
      id: json['_id'] ?? json['id'] ?? '',
      participants: parsedParticipants,
      lastMessage: json['lastMessage'] != null
          ? Message.fromJson(json['lastMessage'])
          : null,
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}

class Message {
  final String id;
  final String chatId;
  final FriendUser? sender;
  final String content;
  final String messageType;
  final String? createdAt;

  Message({
    required this.id,
    required this.chatId,
    this.sender,
    required this.content,
    required this.messageType,
    this.createdAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    FriendUser? parsedSender;
    if (json['sender'] is Map<String, dynamic>) {
      parsedSender = FriendUser.fromJson(json['sender']);
    } else if (json['sender'] is String) {
      parsedSender = FriendUser(id: json['sender']);
    }

    return Message(
      id: json['_id'] ?? json['id'] ?? '',
      chatId: json['chatId'] ?? '',
      sender: parsedSender,
      content: json['content'] ?? '',
      messageType: json['messageType'] ?? 'text',
      createdAt: json['createdAt'],
    );
  }
}

class MessageMeta {
  final int totalMessages;
  final int page;
  final int limit;
  final int totalPages;
  MessageMeta({
    required this.totalMessages,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory MessageMeta.fromJson(Map<String, dynamic> json) {
    return MessageMeta(
      totalMessages: json['total'] ?? 0,
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 40,
      totalPages: json['totalPages'] ?? 1,
    );
  }
}

class PageinatedMessage {
  final List<Message> messages;
  final MessageMeta meta;

  PageinatedMessage({required this.messages, required this.meta});

  factory PageinatedMessage.fromJson(Map<String, dynamic> json) {
    final messageList = json['messages'] as List? ?? [];
    return PageinatedMessage(
      messages: messageList.map((m) => Message.fromJson(m)).toList(),
      meta: MessageMeta.fromJson(json['meta'] ?? {}),
    );
  }
}
