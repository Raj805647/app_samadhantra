
class GetRequirementByIdModel {
  final bool? status;
  final String? message;
  final RequirementDetailData? data;

  GetRequirementByIdModel({
    this.status,
    this.message,
    this.data,
  });

  factory GetRequirementByIdModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return GetRequirementByIdModel();

    return GetRequirementByIdModel(
      status: json['status'],
      message: json['message'],
      data: json['data'] != null
          ? RequirementDetailData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }
}


class RequirementDetailData {
  final String? id;
  final String? userId;
  final String? requirementCategory;
  final String? problemDescription;
  final String? expectedOutcome;
  final String? timeline;
  final String? budgetRange;
  final String? preferredLocation;
  final List<String>? engagementTypes;
  final String? status;
  final String? createdAt;
  final String? updatedAt;

  RequirementDetailData({
    this.id,
    this.userId,
    this.requirementCategory,
    this.problemDescription,
    this.expectedOutcome,
    this.timeline,
    this.budgetRange,
    this.preferredLocation,
    this.engagementTypes,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory RequirementDetailData.fromJson(Map<String, dynamic>? json) {
    if (json == null) return RequirementDetailData();

    return RequirementDetailData(
      id: json['id']?.toString(),
      userId: json['user_id']?.toString(),
      requirementCategory: json['requirement_category']?.toString(),
      problemDescription: json['problem_description']?.toString(),
      expectedOutcome: json['expected_outcome']?.toString(),
      timeline: json['timeline']?.toString(),
      budgetRange: json['budget_range']?.toString(),
      preferredLocation: json['preferred_location']?.toString(),
      engagementTypes: json['engagement_types'] != null
          ? List<String>.from(json['engagement_types'] as List)
          : null,
      status: json['status']?.toString(),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'requirement_category': requirementCategory,
      'problem_description': problemDescription,
      'expected_outcome': expectedOutcome,
      'timeline': timeline,
      'budget_range': budgetRange,
      'preferred_location': preferredLocation,
      'engagement_types': engagementTypes ?? [],
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
