class MyRequirementModel {
  final bool status;
  final String message;
  final List<MyRequirementData> data;

  MyRequirementModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory MyRequirementModel.fromJson(Map<String, dynamic> json) {
    return MyRequirementModel(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => MyRequirementData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class MyRequirementData {
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

  MyRequirementData({
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

  factory MyRequirementData.fromJson(Map<String, dynamic> json) {
    return MyRequirementData(
      id: json['id'],
      userId: json['user_id'],
      requirementCategory: json['requirement_category'],
      problemDescription: json['problem_description'],
      expectedOutcome: json['expected_outcome'],
      timeline: json['timeline'],
      budgetRange: json['budget_range'],
      preferredLocation: json['preferred_location'],
      engagementTypes: (json['engagement_types'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}