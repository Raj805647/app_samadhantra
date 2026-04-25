class TermsConditionResponse {
  TermsConditionResponse({
      this.status, 
      this.message, 
      this.data,});

  TermsConditionResponse.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(TermsConditionsModel.fromJson(v));
      });
    }
  }
  bool? status;
  String? message;
  List<TermsConditionsModel>? data;

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

class TermsConditionsModel {
  TermsConditionsModel({
      this.id, 
      this.title, 
      this.content, 
      this.effectiveDate, 
      this.isActive, 
      this.createdAt, 
      this.updatedAt,});

  TermsConditionsModel.fromJson(dynamic json) {
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