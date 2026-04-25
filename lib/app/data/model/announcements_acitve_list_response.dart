

class AnnouncementsAcitveListResponse {
  AnnouncementsAcitveListResponse({
    bool? status,
    String? message,
    List<AnnouncementData>? data,}){
    _status = status;
    _message = message;
    _data = data;
  }

  AnnouncementsAcitveListResponse.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(AnnouncementData.fromJson(v));
      });
    }
  }
  bool? _status;
  String? _message;
  List<AnnouncementData>? _data;
  AnnouncementsAcitveListResponse copyWith({  bool? status,
    String? message,
    List<AnnouncementData>? data,
  }) => AnnouncementsAcitveListResponse(  status: status ?? _status,
    message: message ?? _message,
    data: data ?? _data,
  );
  bool? get status => _status;
  String? get message => _message;
  List<AnnouncementData>? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class AnnouncementData {
  AnnouncementData({
    String? id,
    String? requirementId,
    String? requirementUserId,
    String? requirementCategory,
    String? problemDescription,
    String? preferredLocation,
    String? expiresAt,
    bool? isActive,}){
    _id = id;
    _requirementId = requirementId;
    _requirementUserId = requirementUserId;
    _requirementCategory = requirementCategory;
    _problemDescription = problemDescription;
    _preferredLocation = preferredLocation;
    _expiresAt = expiresAt;
    _isActive = isActive;
  }

  AnnouncementData.fromJson(dynamic json) {
    _id = json['id'];
    _requirementId = json['requirement_id'];
    _requirementUserId = json['requirement_user_id'];
    _requirementCategory = json['requirement_category'];
    _problemDescription = json['problem_description'];
    _preferredLocation = json['preferred_location'];
    _expiresAt = json['expires_at'];
    _isActive = json['is_active'];
  }
  String? _id;
  String? _requirementId;
  String? _requirementUserId;
  String? _requirementCategory;
  String? _problemDescription;
  String? _preferredLocation;
  String? _expiresAt;
  bool? _isActive;
  AnnouncementData copyWith({  String? id,
    String? requirementId,
    String? requirementUserId,
    String? requirementCategory,
    String? problemDescription,
    String? preferredLocation,
    String? expiresAt,
    bool? isActive,
  }) => AnnouncementData(  id: id ?? _id,
    requirementId: requirementId ?? _requirementId,
    requirementUserId: requirementUserId ?? _requirementUserId,
    requirementCategory: requirementCategory ?? _requirementCategory,
    problemDescription: problemDescription ?? _problemDescription,
    preferredLocation: preferredLocation ?? _preferredLocation,
    expiresAt: expiresAt ?? _expiresAt,
    isActive: isActive ?? _isActive,
  );
  String? get id => _id;
  String? get requirementId => _requirementId;
  String? get requirementUserId => _requirementUserId;
  String? get requirementCategory => _requirementCategory;
  String? get problemDescription => _problemDescription;
  String? get preferredLocation => _preferredLocation;
  String? get expiresAt => _expiresAt;
  bool? get isActive => _isActive;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['requirement_id'] = _requirementId;
    map['requirement_user_id'] = _requirementUserId;
    map['requirement_category'] = _requirementCategory;
    map['problem_description'] = _problemDescription;
    map['preferred_location'] = _preferredLocation;
    map['expires_at'] = _expiresAt;
    map['is_active'] = _isActive;
    return map;
  }

}