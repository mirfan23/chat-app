class ChatListModel {
  final String roomId;
  final String friend;
  final String lastMessage;
  final String lastSender;
  final DateTime lastMessageTime;
  final bool isRead;
  final int unreadCount;

  ChatListModel({
    required this.roomId,
    required this.friend,
    required this.lastMessage,
    required this.lastSender,
    required this.lastMessageTime,
    required this.isRead,
    required this.unreadCount,
  });

  factory ChatListModel.fromJson(Map<String, dynamic> json) {
    return ChatListModel(
      roomId: json["roomId"] ?? "",
      friend: json["friend"] ?? "",
      lastMessage: json["lastMessage"] ?? "",
      lastSender: json["lastSender"] ?? "",
      lastMessageTime: DateTime.tryParse(json["lastMessageTime"] ?? "") ?? DateTime.now(),
      isRead: json["isRead"] ?? false,
      unreadCount: json["unreadCount"] ?? 0,
    );
  }
}
