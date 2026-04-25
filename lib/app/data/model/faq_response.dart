class FaqResponse {
  FaqResponse({
      bool? status, 
      String? message, 
      List<FAQData>? data,}){
    _status = status;
    _message = message;
    _data = data;
}

  FaqResponse.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(FAQData.fromJson(v));
      });
    }
  }
  bool? _status;
  String? _message;
  List<FAQData>? _data;
  FaqResponse copyWith({  bool? status,
  String? message,
  List<FAQData>? data,
}) => FaqResponse(  status: status ?? _status,
  message: message ?? _message,
  data: data ?? _data,
);
  bool? get status => _status;
  String? get message => _message;
  List<FAQData>? get data => _data;

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

class FAQData {
  FAQData({
      String? id, 
      String? question, 
      String? answer, 
      String? category, 
      List<String>? keywords, 
      num? priority, 
      bool? isActive, 
      String? createdAt, 
      String? updatedAt,}){
    _id = id;
    _question = question;
    _answer = answer;
    _category = category;
    _keywords = keywords;
    _priority = priority;
    _isActive = isActive;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
}

  FAQData.fromJson(dynamic json) {
    _id = json['id'];
    _question = json['question'];
    _answer = json['answer'];
    _category = json['category'];
    _keywords = json['keywords'] != null ? json['keywords'].cast<String>() : [];
    _priority = json['priority'];
    _isActive = json['is_active'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }
  String? _id;
  String? _question;
  String? _answer;
  String? _category;
  List<String>? _keywords;
  num? _priority;
  bool? _isActive;
  String? _createdAt;
  String? _updatedAt;
FAQData copyWith({  String? id,
  String? question,
  String? answer,
  String? category,
  List<String>? keywords,
  num? priority,
  bool? isActive,
  String? createdAt,
  String? updatedAt,
}) => FAQData(  id: id ?? _id,
  question: question ?? _question,
  answer: answer ?? _answer,
  category: category ?? _category,
  keywords: keywords ?? _keywords,
  priority: priority ?? _priority,
  isActive: isActive ?? _isActive,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
);
  String? get id => _id;
  String? get question => _question;
  String? get answer => _answer;
  String? get category => _category;
  List<String>? get keywords => _keywords;
  num? get priority => _priority;
  bool? get isActive => _isActive;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  get helpfulCount => null;// manually add

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['question'] = _question;
    map['answer'] = _answer;
    map['category'] = _category;
    map['keywords'] = _keywords;
    map['priority'] = _priority;
    map['is_active'] = _isActive;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    return map;
  }

}