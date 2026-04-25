// Main response model - data is a single object, not a list
class ChatSessionResponse {
  bool? status;
  String? message;
  SessionData? data;  // Changed from List<SessionData>? to SessionData?

  ChatSessionResponse({this.status, this.message, this.data});

  ChatSessionResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = SessionData.fromJson(json['data']);
    }
  }

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

// SessionData model - contains session_id and messages list
class SessionData {
  String? sessionId;
  List<Messages>? messages;

  SessionData({this.sessionId, this.messages});

  SessionData.fromJson(Map<String, dynamic> json) {
    sessionId = json['session_id'];

    if (json['messages'] != null && json['messages'] is List) {
      messages = (json['messages'] as List)
          .map((v) => Messages.fromJson(v))
          .toList();
    } else {
      messages = [];
    }
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['session_id'] = sessionId;
    if (messages != null) {
      map['messages'] = messages?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

// Messages model remains the same
class Messages {
  String? id;
  String? sender;
  String? user_id;
  String? message;
  String? createdAt;

  Messages({this.id, this.sender, this.message, this.createdAt});

  Messages.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    sender = json['sender']?.toString();
    user_id = json['user_id']?.toString();
    message = json['message']?.toString();
    createdAt = json['created_at']?.toString();
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['sender'] = sender;
    map['user_id'] = user_id;
    map['message'] = message;
    map['created_at'] = createdAt;
    return map;
  }
}