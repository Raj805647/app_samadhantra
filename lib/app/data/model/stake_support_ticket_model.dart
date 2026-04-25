class SupportTicket {
  final String id;
  final String title;
  final String description;
  final String category; // 'technical', 'billing', 'account', 'general'
  final String priority; // 'low', 'medium', 'high', 'urgent'
  final String status; // 'open', 'in-progress', 'resolved', 'closed'
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? assignedTo;
  final List<TicketMessage> messages;

  SupportTicket({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.priority,
    required this.status,
    required this.createdAt,
    this.updatedAt,
    this.assignedTo,
    this.messages = const [],
  });

  factory SupportTicket.fromJson(Map<String, dynamic> json) {
    return SupportTicket(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      category: json['category'],
      priority: json['priority'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
      assignedTo: json['assigned_to'],
      messages: (json['messages'] as List).map((e) => TicketMessage.fromJson(e)).toList(),
    );
  }

  String get formattedCreatedAt {
    return '${createdAt.day}/${createdAt.month}/${createdAt.year} ${createdAt.hour}:${createdAt.minute}';
  }
}

class TicketMessage {
  final String id;
  final String senderType; // 'user', 'support'
  final String senderName;
  final String message;
  final DateTime timestamp;
  final List<String> attachments;

  TicketMessage({
    required this.id,
    required this.senderType,
    required this.senderName,
    required this.message,
    required this.timestamp,
    this.attachments = const [],
  });

  factory TicketMessage.fromJson(Map<String, dynamic> json) {
    return TicketMessage(
      id: json['id'],
      senderType: json['sender_type'],
      senderName: json['sender_name'],
      message: json['message'],
      timestamp: DateTime.parse(json['timestamp']),
      attachments: List<String>.from(json['attachments'] ?? []),
    );
  }
}