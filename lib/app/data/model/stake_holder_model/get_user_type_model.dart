class GetUserTypeResponse {
  bool? status;
  String? message;
  GetUserTypeData? data;

  GetUserTypeResponse({this.status, this.message, this.data});

  GetUserTypeResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null
        ? GetUserTypeData.fromJson(json['data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}
class GetUserTypeData {
  List<UserTypes>? userTypes;

  GetUserTypeData({this.userTypes});

  GetUserTypeData.fromJson(Map<String, dynamic> json) {
    if (json['user_types'] != null) {
      userTypes = <UserTypes>[];
      json['user_types'].forEach((v) {
        userTypes!.add(UserTypes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (userTypes != null) {
      data['user_types'] = userTypes!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UserTypes {
  String? value;
  String? label;
  String? iconUrl;
  int? subscriptionAmountInr;

  UserTypes({
    this.value,
    this.label,
    this.iconUrl,
    this.subscriptionAmountInr,
  });

  UserTypes.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    label = json['label'];
    iconUrl = json['icon_url'];
    subscriptionAmountInr = json['subscription_amount_inr'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['value'] = value;
    data['label'] = label;
    data['icon_url'] = iconUrl;
    data['subscription_amount_inr'] = subscriptionAmountInr;
    return data;
  }
}

