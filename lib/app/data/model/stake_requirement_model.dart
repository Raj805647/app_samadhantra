// stake_requirement_model.dart
import 'package:flutter/material.dart';

class RequirementModel {
  final String id;
  final String title;
  final String category;
  final String description;
  final String status;
  final int proposalsCount;
  final DateTime createdAt;
  final String budget;
  final DateTime? deadline;
  final String? location;
  final List<String> attachments;
  final List<ProposalModel> proposals;

  RequirementModel({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.status,
    required this.proposalsCount,
    required this.createdAt,
    required this.budget,
    this.deadline,
    this.location,
    this.attachments = const [],
    this.proposals = const [],
  });

  Color get statusColor {
    switch (status.toLowerCase()) {
      case 'active':
        return Colors.green;
      case 'in_review':
        return Colors.orange;
      case 'completed':
        return Colors.blue;
      case 'pending':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  String get statusText {
    switch (status.toLowerCase()) {
      case 'active':
        return 'Active';
      case 'in_review':
        return 'In Review';
      case 'completed':
        return 'Completed';
      case 'pending':
        return 'Pending';
      default:
        return status;
    }
  }

  String get formattedDate {
    return '${createdAt.day}/${createdAt.month}/${createdAt.year}';
  }

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return formattedDate;
    }
  }

  String? get formattedDeadline {
    if (deadline == null) return null;
    return '${deadline!.day}/${deadline!.month}/${deadline!.year}';
  }
}

class ProposalModel {
  final String id;
  final String providerName;
  final String providerImage;
  final String providerRating;
  final String price;
  final String timeline;
  final String description;
  final String status; // submitted, accepted, rejected
  final DateTime submittedDate;

  ProposalModel({
    required this.id,
    required this.providerName,
    required this.providerImage,
    required this.providerRating,
    required this.price,
    required this.timeline,
    required this.description,
    required this.status,
    required this.submittedDate,
  });

  Color get statusColor {
    switch (status.toLowerCase()) {
      case 'accepted':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  String get statusText {
    switch (status.toLowerCase()) {
      case 'accepted':
        return 'Accepted';
      case 'rejected':
        return 'Rejected';
      default:
        return 'Submitted';
    }
  }
}