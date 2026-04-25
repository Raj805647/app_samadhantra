class AssignmentDetailsResponse {
  AssignmentDetailsResponse({
      this.status, 
      this.message, 
      this.data,});

  AssignmentDetailsResponse.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? AssignmentDetailsData.fromJson(json['data']) : null;
  }
  bool? status;
  String? message;
  AssignmentDetailsData? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    if (data != null) {
      map['data'] = data?.toJson();
    }
    return map;
  }

}

class AssignmentDetailsData {
  AssignmentDetailsData({
      this.requirementTitle, 
      this.providerName, 
      this.providerImage, 
      this.status, 
      this.assignedDate, 
      this.startDate, 
      this.budget, 
      this.milestones, 
      this.documents,});

  AssignmentDetailsData.fromJson(dynamic json) {
    requirementTitle = json['requirementTitle'];
    providerName = json['providerName'];
    providerImage = json['providerImage'];
    status = json['status'];
    assignedDate = json['assignedDate'];
    startDate = json['startDate'];
    budget = json['budget'];
    if (json['milestones'] != null) {
      milestones = [];
      json['milestones'].forEach((v) {
        milestones?.add(Milestones.fromJson(v));
      });
    }
    if (json['documents'] != null) {
      documents = [];
      json['documents'].forEach((v) {
        documents?.add(Documents.fromJson(v));
      });
    }
  }
  String? requirementTitle;
  String? providerName;
  dynamic providerImage;
  String? status;
  String? assignedDate;
  String? startDate;
  double? budget;
  List<Milestones>? milestones;
  List<Documents>? documents;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['requirementTitle'] = requirementTitle;
    map['providerName'] = providerName;
    map['providerImage'] = providerImage;
    map['status'] = status;
    map['assignedDate'] = assignedDate;
    map['startDate'] = startDate;
    map['budget'] = budget;
    if (milestones != null) {
      map['milestones'] = milestones?.map((v) => v.toJson()).toList();
    }
    if (documents != null) {
      map['documents'] = documents?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class Documents {
  Documents({
      this.name, 
      this.type, 
      this.url, 
      this.uploadDate, 
      this.uploader,});

  Documents.fromJson(dynamic json) {
    name = json['name'];
    type = json['type'];
    url = json['url'];
    uploadDate = json['uploadDate'];
    uploader = json['uploader'];
  }
  String? name;
  String? type;
  String? url;
  String? uploadDate;
  String? uploader;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['type'] = type;
    map['url'] = url;
    map['uploadDate'] = uploadDate;
    map['uploader'] = uploader;
    return map;
  }

}

class Milestones {
  Milestones({
      this.title, 
      this.description, 
      this.dueDate, 
      this.status, 
      this.completedDate,});

  Milestones.fromJson(dynamic json) {
    title = json['title'];
    description = json['description'];
    dueDate = json['dueDate'];
    status = json['status'];
    completedDate = json['completedDate'];
  }
  String? title;
  String? description;
  String? dueDate;
  String? status;
  dynamic completedDate;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['title'] = title;
    map['description'] = description;
    map['dueDate'] = dueDate;
    map['status'] = status;
    map['completedDate'] = completedDate;
    return map;
  }

}