class PrivacyPolicyResponse {
  PrivacyPolicyResponse({
      this.status, 
      this.message, 
      this.data,});

  PrivacyPolicyResponse.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(PrivacyPolicyModel.fromJson(v));
      });
    }
  }
  bool? status;
  String? message;
  List<PrivacyPolicyModel>? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class PrivacyPolicyModel {
  PrivacyPolicyModel({
      this.id, 
      this.title, 
      this.content, 
      this.effectiveDate, 
      this.isActive, 
      this.createdAt, 
      this.updatedAt,});

  PrivacyPolicyModel.fromJson(dynamic json) {
    id = json['id'];
    title = json['title'];
    content = json['content'];
    effectiveDate = json['effective_date'];
    isActive = json['is_active'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
  String? id;
  String? title;
  String? content;
  String? effectiveDate;
  bool? isActive;
  String? createdAt;
  String? updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['title'] = title;
    map['content'] = content;
    map['effective_date'] = effectiveDate;
    map['is_active'] = isActive;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    return map;
  }

}