import 'dart:convert';

class ChatMessage {
  final String content;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.content,
    required this.isUser,
    required this.timestamp,
  });

  factory ChatMessage.fromSocket(dynamic data) {
    try {
      final decoded = jsonDecode(data);

      return ChatMessage(
        content: decoded['message'] ?? decoded['content'] ?? '',
        isUser: false,
        timestamp: DateTime.now(),
      );
    } catch (_) {
      return ChatMessage(
        content: data.toString(),
        isUser: false,
        timestamp: DateTime.now(),
      );
    }
  }
}
