class ProviderRequesterChattingResponse {
  ProviderRequesterChattingResponse({
      this.status, 
      this.message, 
      this.data,});

  ProviderRequesterChattingResponse.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(ChattingListData.fromJson(v));
      });
    }
  }
  bool? status;
  String? message;
  List<ChattingListData>? data;

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

class ChattingListData {
  ChattingListData({
      this.requirementId, 
      this.userId, 
      this.sessionId, 
      this.accessToken, 
      this.isActive, 
      this.myRole, 
      this.userName, 
      this.userProfileUrl, 
      this.requirementBidId,});

  ChattingListData.fromJson(dynamic json) {
    requirementId = json['requirement_id'];
    userId = json['user_id'];
    sessionId = json['session_id'];
    accessToken = json['access_token'];
    isActive = json['is_active'];
    myRole = json['my_role'];
    userName = json['user_name'];
    userProfileUrl = json['user_profile_url'];
    requirementBidId = json['requirement_bid_id'];
  }
  String? requirementId;
  String? userId;
  String? sessionId;
  String? accessToken;
  bool? isActive;
  String? myRole;
  String? userName;
  dynamic userProfileUrl;
  String? requirementBidId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['requirement_id'] = requirementId;
    map['user_id'] = userId;
    map['session_id'] = sessionId;
    map['access_token'] = accessToken;
    map['is_active'] = isActive;
    map['my_role'] = myRole;
    map['user_name'] = userName;
    map['user_profile_url'] = userProfileUrl;
    map['requirement_bid_id'] = requirementBidId;
    return map;
  }

}