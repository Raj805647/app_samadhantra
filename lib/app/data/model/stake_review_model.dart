// models/stake_review_model.dart
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class Review {
  final String id;
  final String assignmentId;
  final String assignmentTitle;
  final String providerId;
  final String providerName;
  final String providerImage;
  final double rating;
  final String comment;
  final List<String> tags;
  final DateTime reviewDate;
  final String status; // published, draft, hidden
  final bool? wouldRecommend;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Review({
    required this.id,
    required this.assignmentId,
    required this.assignmentTitle,
    required this.providerId,
    required this.providerName,
    this.providerImage = '',
    required this.rating,
    required this.comment,
    this.tags = const [],
    required this.reviewDate,
    this.status = 'published',
    this.wouldRecommend,
    this.createdAt,
    this.updatedAt,
  });

  String get formattedDate {
    return DateFormat('dd MMM yyyy').format(reviewDate);
  }

  String get formattedDateTime {
    return DateFormat('dd MMM yyyy, hh:mm a').format(reviewDate);
  }

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(reviewDate);

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

  List<String> get defaultTags {
    if (rating >= 4.5) return ['Excellent', 'Highly Recommended'];
    if (rating >= 4.0) return ['Great', 'Recommended'];
    if (rating >= 3.0) return ['Good', 'Satisfactory'];
    if (rating >= 2.0) return ['Average', 'Could Improve'];
    return ['Poor', 'Needs Improvement'];
  }

  List<String> get allTags {
    return [...tags, ...defaultTags];
  }

  Color get ratingColor {
    if (rating >= 4.5) return Colors.green;
    if (rating >= 4.0) return Colors.lightGreen;
    if (rating >= 3.0) return Colors.orange;
    if (rating >= 2.0) return Colors.orange[300]!;
    return Colors.red;
  }
}

class ProviderRating {
  final String providerId;
  final String providerName;
  final String providerImage;
  final String providerCategory;
  final double averageRating;
  final int totalReviews;
  final Map<int, int> ratingDistribution;
  final int completedProjects;
  final String experience;
  final String location;
  final String about;
  final List<Review> recentReviews;
  final bool isFavorite;

  ProviderRating({
    required this.providerId,
    required this.providerName,
    required this.providerImage,
    required this.providerCategory,
    required this.averageRating,
    required this.totalReviews,
    required this.ratingDistribution,
    required this.completedProjects,
    this.experience = '5+ years',
    this.location = 'Mumbai, India',
    this.about = '',
    this.recentReviews = const [],
    this.isFavorite = false,
  });

  String get formattedRating {
    return averageRating.toStringAsFixed(1);
  }

  double get ratingPercentage {
    return (averageRating / 5) * 100;
  }

  List<String> get strengths {
    if (averageRating >= 4.5) {
      return ['Excellent Communication', 'On-time Delivery', 'High Quality Work'];
    } else if (averageRating >= 4.0) {
      return ['Good Communication', 'Reliable', 'Quality Work'];
    } else if (averageRating >= 3.0) {
      return ['Satisfactory', 'Good Value'];
    }
    return ['Needs Improvement'];
  }
}