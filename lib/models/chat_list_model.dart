class ChatListModel {
  final String roomId;
  final String friend;
  final String lastMessage;
  final String lastSender;
  final DateTime lastMessageTime;
  final bool isRead;
  final int unreadCount;
  final bool isOnline;

  ChatListModel({
    required this.roomId,
    required this.friend,
    required this.lastMessage,
    required this.lastSender,
    required this.lastMessageTime,
    required this.isRead,
    required this.unreadCount,
    required this.isOnline,
  });

  ChatListModel copyWith({
    String? roomId,
    String? friend,
    String? lastMessage,
    String? lastSender,
    DateTime? lastMessageTime,
    bool? isRead,
    int? unreadCount,
    bool? isOnline,
  }) {
    return ChatListModel(
      roomId: roomId ?? this.roomId,
      friend: friend ?? this.friend,
      lastMessage: lastMessage ?? this.lastMessage,
      lastSender: lastSender ?? this.lastSender,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      isRead: isRead ?? this.isRead,
      unreadCount: unreadCount ?? this.unreadCount,
      isOnline: isOnline ?? this.isOnline,
    );
  }

  factory ChatListModel.fromJson(Map<String, dynamic> json) {
    return ChatListModel(
      roomId: json["roomId"] ?? "",
      friend: json["friend"] ?? "",
      lastMessage: json["lastMessage"] ?? "",
      lastSender: json["lastSender"] ?? "",
      lastMessageTime: DateTime.tryParse(json["lastMessageTime"] ?? "") ?? DateTime.now(),
      isRead: json["isRead"] ?? false,
      unreadCount: json["unreadCount"] ?? 0,
      isOnline: json["isOnline"] ?? false,
    );
  }
}
