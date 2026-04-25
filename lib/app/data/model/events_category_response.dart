class EventsCategoryResponse {
  EventsCategoryResponse({
      bool? status, 
      String? message, 
      List<EventsCategoryData>? data,}){
    _status = status;
    _message = message;
    _data = data;
}

  EventsCategoryResponse.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(EventsCategoryData.fromJson(v));
      });
    }
  }
  bool? _status;
  String? _message;
  List<EventsCategoryData>? _data;
EventsCategoryResponse copyWith({  bool? status,
  String? message,
  List<EventsCategoryData>? data,
}) => EventsCategoryResponse(  status: status ?? _status,
  message: message ?? _message,
  data: data ?? _data,
);
  bool? get status => _status;
  String? get message => _message;
  List<EventsCategoryData>? get data => _data;

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

class EventsCategoryData {
  EventsCategoryData({
      String? id, 
      String? title, 
      String? subTitle, 
      String? image, 
      bool? isActive, 
      String? createdAt, 
      String? updatedAt,}){
    _id = id;
    _title = title;
    _subTitle = subTitle;
    _image = image;
    _isActive = isActive;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
}

  EventsCategoryData.fromJson(dynamic json) {
    _id = json['id'];
    _title = json['title'];
    _subTitle = json['sub_title'];
    _image = json['image'];
    _isActive = json['is_active'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }
  String? _id;
  String? _title;
  String? _subTitle;
  String? _image;
  bool? _isActive;
  String? _createdAt;
  String? _updatedAt;
EventsCategoryData copyWith({  String? id,
  String? title,
  String? subTitle,
  String? image,
  bool? isActive,
  String? createdAt,
  String? updatedAt,
}) => EventsCategoryData(  id: id ?? _id,
  title: title ?? _title,
  subTitle: subTitle ?? _subTitle,
  image: image ?? _image,
  isActive: isActive ?? _isActive,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
);
  String? get id => _id;
  String? get title => _title;
  String? get subTitle => _subTitle;
  String? get image => _image;
  bool? get isActive => _isActive;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['title'] = _title;
    map['sub_title'] = _subTitle;
    map['image'] = _image;
    map['is_active'] = _isActive;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    return map;
  }

}