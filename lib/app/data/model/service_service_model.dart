import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ServiceModel {
  final String id;
  final String name;
  final String description;
  final double hourlyRate;
  final double dailyRate;
  final double projectRate;
  final String category;
  final List<String> tags;
  final bool isActive;
  final bool isFeatured;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final List<String> skills;
  final String experienceLevel;
  final int deliveryDays;
  final String icon;

  ServiceModel({
    required this.id,
    required this.name,
    required this.description,
    required this.hourlyRate,
    required this.dailyRate,
    required this.projectRate,
    required this.category,
    required this.tags,
    required this.isActive,
    required this.isFeatured,
    required this.createdAt,
    this.updatedAt,
    required this.skills,
    required this.experienceLevel,
    required this.deliveryDays,
    required this.icon,
  });

  // Add these getters
  String get formattedCreatedDate {
    return DateFormat('dd MMM yyyy, hh:mm a').format(createdAt);
  }

  String get formattedUpdatedDate {
    if (updatedAt != null) {
      return DateFormat('dd MMM yyyy, hh:mm a').format(updatedAt!);
    }
    return 'Never updated';
  }

  String get formattedHourlyRate {
    return '₹${hourlyRate.toInt()}';
  }

  String get formattedDailyRate {
    return '₹${dailyRate.toInt()}';
  }

  String get formattedProjectRate {
    return '₹${projectRate.toInt()}';
  }

  Color get statusColor {
    return isActive ? Colors.green : Colors.red;
  }

  IconData get statusIcon {
    return isActive ? Icons.check_circle : Icons.pause_circle;
  }

  String get statusText {
    return isActive ? 'Active' : 'Inactive';
  }

  // Copy with method
  ServiceModel copyWith({
    String? id,
    String? name,
    String? description,
    double? hourlyRate,
    double? dailyRate,
    double? projectRate,
    String? category,
    List<String>? tags,
    bool? isActive,
    bool? isFeatured,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<String>? skills,
    String? experienceLevel,
    int? deliveryDays,
    String? icon,
  }) {
    return ServiceModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      hourlyRate: hourlyRate ?? this.hourlyRate,
      dailyRate: dailyRate ?? this.dailyRate,
      projectRate: projectRate ?? this.projectRate,
      category: category ?? this.category,
      tags: tags ?? this.tags,
      isActive: isActive ?? this.isActive,
      isFeatured: isFeatured ?? this.isFeatured,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      skills: skills ?? this.skills,
      experienceLevel: experienceLevel ?? this.experienceLevel,
      deliveryDays: deliveryDays ?? this.deliveryDays,
      icon: icon ?? this.icon,
    );
  }

  // Factory method for JSON
  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      hourlyRate: json['hourlyRate'].toDouble(),
      dailyRate: json['dailyRate'].toDouble(),
      projectRate: json['projectRate'].toDouble(),
      category: json['category'],
      tags: List<String>.from(json['tags']),
      isActive: json['isActive'],
      isFeatured: json['isFeatured'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      skills: List<String>.from(json['skills']),
      experienceLevel: json['experienceLevel'],
      deliveryDays: json['deliveryDays'],
      icon: json['icon'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'hourlyRate': hourlyRate,
      'dailyRate': dailyRate,
      'projectRate': projectRate,
      'category': category,
      'tags': tags,
      'isActive': isActive,
      'isFeatured': isFeatured,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'skills': skills,
      'experienceLevel': experienceLevel,
      'deliveryDays': deliveryDays,
      'icon': icon,
    };
  }
}