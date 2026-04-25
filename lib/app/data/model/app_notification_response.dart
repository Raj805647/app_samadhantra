class AppNotification {
  final String id;
  final String title;
  final String body;
  final String type;
  final String? requirementId;
  final String? createdAt;

  AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    this.requirementId,
    this.createdAt,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id']?.toString() ?? "",
      title: json['title'] ?? "Notification",
      body: json['body'] ?? "",
      type: json['type'] ?? "",
      requirementId: json['requirement_id']?.toString(),
      createdAt: json['created_at'],
    );
  }
}