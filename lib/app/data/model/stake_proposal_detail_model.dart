// models/proposal_detail_model.dart
import 'package:flutter/material.dart';

class ProposalDetailModel {
  final String id;
  final String requirementId;
  final String requirementTitle;
  final String providerId;
  final String providerName;
  final String providerImage;
  final String providerRating;
  final int providerCompletedProjects;
  final String providerDescription;
  final String price;
  final String timeline;
  final String description;
  final String status; // submitted, accepted, rejected, withdrawn
  final DateTime submittedDate;
  final DateTime? acceptedDate;
  final DateTime? rejectedDate;
  final List<String> attachments;
  final List<MessageModel> messages;
  final String termsAndConditions;
  final String additionalNotes;

  ProposalDetailModel({
    required this.id,
    required this.requirementId,
    required this.requirementTitle,
    required this.providerId,
    required this.providerName,
    required this.providerImage,
    required this.providerRating,
    required this.providerCompletedProjects,
    required this.providerDescription,
    required this.price,
    required this.timeline,
    required this.description,
    required this.status,
    required this.submittedDate,
    this.acceptedDate,
    this.rejectedDate,
    this.attachments = const [],
    this.messages = const [],
    this.termsAndConditions = '',
    this.additionalNotes = '',
  });

  // Helper methods
  Color get statusColor {
    switch (status) {
      case 'accepted':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'withdrawn':
        return Colors.orange;
      case 'submitted':
      default:
        return Colors.blue;
    }
  }

  String get statusText {
    switch (status) {
      case 'accepted':
        return 'Accepted';
      case 'rejected':
        return 'Rejected';
      case 'withdrawn':
        return 'Withdrawn';
      case 'submitted':
      default:
        return 'Submitted';
    }
  }

  String get formattedSubmittedDate {
    return '${submittedDate.day}/${submittedDate.month}/${submittedDate.year}';
  }

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(submittedDate);

    if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else {
      return 'Just now';
    }
  }
}

class MessageModel {
  final String id;
  final String senderId;
  final String senderName;
  final String message;
  final DateTime timestamp;
  final bool isRead;

  MessageModel({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.message,
    required this.timestamp,
    this.isRead = false, required receiverId,
  });

  String get formattedTime {
    return '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
  }
}