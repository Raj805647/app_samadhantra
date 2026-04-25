// lib/app/data/model/service_notification_model.dart
import 'package:flutter/material.dart';

class ServiceNotificationModel {
  final String id;
  final String title;
  final String message;
  final NotificationType type;
  final String? assignmentId;
  final String? proposalId;
  final String? requirementId;
  final DateTime dateTime;
  final bool isRead;
  final Map<String, dynamic>? data;

  ServiceNotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    this.assignmentId,
    this.proposalId,
    this.requirementId,
    required this.dateTime,
    required this.isRead,
    this.data,
  });

  factory ServiceNotificationModel.fromJson(Map<String, dynamic> json) {
    return ServiceNotificationModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      type: _parseNotificationType(json['type']),
      assignmentId: json['assignmentId'],
      proposalId: json['proposalId'],
      requirementId: json['requirementId'],
      dateTime: DateTime.parse(json['dateTime']),
      isRead: json['isRead'] ?? false,
      data: json['data'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'type': type.toString().split('.').last,
      'assignmentId': assignmentId,
      'proposalId': proposalId,
      'requirementId': requirementId,
      'dateTime': dateTime.toIso8601String(),
      'isRead': isRead,
      'data': data,
    };
  }

  static NotificationType _parseNotificationType(String type) {
    switch (type.toLowerCase()) {
      case 'proposal':
        return NotificationType.proposal;
      case 'assignment':
        return NotificationType.assignment;
      case 'payment':
        return NotificationType.payment;
      case 'system':
        return NotificationType.system;
      case 'message':
        return NotificationType.message;
      case 'review':
        return NotificationType.review;
      default:
        return NotificationType.system;
    }
  }

  String get formattedDate {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 7) {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }

  IconData get icon {
    switch (type) {
      case NotificationType.proposal:
        return Icons.description;
      case NotificationType.assignment:
        return Icons.assignment;
      case NotificationType.payment:
        return Icons.payments;
      case NotificationType.system:
        return Icons.notifications;
      case NotificationType.message:
        return Icons.message;
      case NotificationType.review:
        return Icons.star;
    }
  }

  Color get iconColor {
    switch (type) {
      case NotificationType.proposal:
        return Colors.blue;
      case NotificationType.assignment:
        return Colors.green;
      case NotificationType.payment:
        return Colors.orange;
      case NotificationType.system:
        return Colors.purple;
      case NotificationType.message:
        return Colors.teal;
      case NotificationType.review:
        return Colors.amber;
    }
  }
}

enum NotificationType {
  proposal,
  assignment,
  payment,
  system,
  message,
  review,
}

enum NotificationFilter {
  all,
  unread,
  proposal,
  assignment,
  payment,
}