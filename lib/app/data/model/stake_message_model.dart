class MessageThread {
  final String id;
  final String message;
  final String senderType;
  final String senderName;
  final DateTime timestamp;
  final bool isRead;

  MessageThread({
    required this.id,
    required this.message,
    required this.senderType,
    required this.senderName,
    required this.timestamp,
    required this.isRead,
  });

  factory MessageThread.fromJson(Map<String, dynamic> json) {
    return MessageThread(
      id: json['id'],
      message: json['message'],
      senderType: json['senderType'],
      senderName: json['senderName'],
      timestamp: DateTime.parse(json['timestamp']),
      isRead: json['isRead'],
    );
  }
}