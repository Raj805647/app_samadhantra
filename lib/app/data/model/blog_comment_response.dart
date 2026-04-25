class BlogCommentResponse {
  BlogCommentResponse({
      bool? status, 
      String? message, 
      List<BlogCommentListData>? data,}){
    _status = status;
    _message = message;
    _data = data;
}

  BlogCommentResponse.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(BlogCommentListData.fromJson(v));
      });
    }
  }
  bool? _status;
  String? _message;
  List<BlogCommentListData>? _data;
BlogCommentResponse copyWith({  bool? status,
  String? message,
  List<BlogCommentListData>? data,
}) => BlogCommentResponse(  status: status ?? _status,
  message: message ?? _message,
  data: data ?? _data,
);
  bool? get status => _status;
  String? get message => _message;
  List<BlogCommentListData>? get data => _data;

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

class BlogCommentListData {
  BlogCommentListData({
      String? id, 
      String? blogId, 
      String? authorName, 
      String? authorEmail, 
      String? content, 
      bool? isApproved, 
      String? createdAt, 
      String? approvedAt,}){
    _id = id;
    _blogId = blogId;
    _authorName = authorName;
    _authorEmail = authorEmail;
    _content = content;
    _isApproved = isApproved;
    _createdAt = createdAt;
    _approvedAt = approvedAt;
}

  BlogCommentListData.fromJson(dynamic json) {
    _id = json['id'];
    _blogId = json['blog_id'];
    _authorName = json['author_name'];
    _authorEmail = json['author_email'];
    _content = json['content'];
    _isApproved = json['is_approved'];
    _createdAt = json['created_at'];
    _approvedAt = json['approved_at'];
  }
  String? _id;
  String? _blogId;
  String? _authorName;
  String? _authorEmail;
  String? _content;
  bool? _isApproved;
  String? _createdAt;
  String? _approvedAt;
BlogCommentListData copyWith({  String? id,
  String? blogId,
  String? authorName,
  String? authorEmail,
  String? content,
  bool? isApproved,
  String? createdAt,
  String? approvedAt,
}) => BlogCommentListData(  id: id ?? _id,
  blogId: blogId ?? _blogId,
  authorName: authorName ?? _authorName,
  authorEmail: authorEmail ?? _authorEmail,
  content: content ?? _content,
  isApproved: isApproved ?? _isApproved,
  createdAt: createdAt ?? _createdAt,
  approvedAt: approvedAt ?? _approvedAt,
);
  String? get id => _id;
  String? get blogId => _blogId;
  String? get authorName => _authorName;
  String? get authorEmail => _authorEmail;
  String? get content => _content;
  bool? get isApproved => _isApproved;
  String? get createdAt => _createdAt;
  String? get approvedAt => _approvedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['blog_id'] = _blogId;
    map['author_name'] = _authorName;
    map['author_email'] = _authorEmail;
    map['content'] = _content;
    map['is_approved'] = _isApproved;
    map['created_at'] = _createdAt;
    map['approved_at'] = _approvedAt;
    return map;
  }

}