// stake_assignment_model.dart
class Assignment {
  final String? id;
  final String requirementTitle;
  final String providerName;
  final String providerImage;
  final String status;
  final DateTime assignedDate;
  final DateTime? startDate;
  final DateTime? completionDate;
  final double budget;
  final List<Milestone> milestones;
  final List<Document> documents;
  final bool isReviewed;

  Assignment({
    this.id,
    required this.requirementTitle,
    required this.providerName,
    required this.providerImage,
    required this.status,
    required this.assignedDate,
    this.startDate,
    this.completionDate,
    required this.budget,
    required this.milestones,
    required this.documents,
    this.isReviewed = false,
  });

  // Add a static method to create empty assignment
  static Assignment empty() {
    return Assignment(
      id: null,
      requirementTitle: '',
      providerName: '',
      providerImage: '',
      status: '',
      assignedDate: DateTime.now(),
      budget: 0.0,
      milestones: [],
      documents: [],
    );
  }

  // Add formatted date getter
  String get formattedAssignedDate {
    return '${assignedDate.day}/${assignedDate.month}/${assignedDate.year}';
  }
  bool get canBeReviewed {
    return status == 'COMPLETED' && !isReviewed;
  }
}

class Milestone {
  final String id;
  final String title;
  final String description;
  final DateTime dueDate;
  final String status;
  final DateTime? completedDate;

  Milestone({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.status,
    this.completedDate,
  });

  String get formattedDueDate {
    return '${dueDate.day}/${dueDate.month}/${dueDate.year}';
  }
}

class Document {
  final String id;
  final String name;
  final String type;
  final String url;
  final DateTime uploadDate;
  final String uploader;

  Document({
    required this.id,
    required this.name,
    required this.type,
    required this.url,
    required this.uploadDate,
    required this.uploader,
  });
}