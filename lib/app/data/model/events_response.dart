class EventsResponse {
  EventsResponse({
      bool? status, 
      String? message, 
      List<EventsData>? data,}){
    _status = status;
    _message = message;
    _data = data;
}

  EventsResponse.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(EventsData.fromJson(v));
      });
    }
  }
  bool? _status;
  String? _message;
  List<EventsData>? _data;
EventsResponse copyWith({  bool? status,
  String? message,
  List<EventsData>? data,
}) => EventsResponse(  status: status ?? _status,
  message: message ?? _message,
  data: data ?? _data,
);
  bool? get status => _status;
  String? get message => _message;
  List<EventsData>? get data => _data;

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

class EventsData {
  EventsData({
      String? id, 
      String? categoryId, 
      String? name, 
      String? slug, 
      String? date, 
      String? description, 
      String? image, 
      String? video, 
      String? youtubeVideo, 
      String? instagramPost, 
      String? metaDescription, 
      String? metaKeywords, 
      String? robots, 
      String? metaAuthor, 
      String? canonicalUrl, 
      String? ogTitle, 
      String? ogDescription, 
      String? ogImage, 
      String? ogUrl, 
      String? ogType, 
      String? ogSiteName, 
      String? ogLocale, 
      bool? isActive, 
      String? createdAt, 
      String? updatedAt,}){
    _id = id;
    _categoryId = categoryId;
    _name = name;
    _slug = slug;
    _date = date;
    _description = description;
    _image = image;
    _video = video;
    _youtubeVideo = youtubeVideo;
    _instagramPost = instagramPost;
    _metaDescription = metaDescription;
    _metaKeywords = metaKeywords;
    _robots = robots;
    _metaAuthor = metaAuthor;
    _canonicalUrl = canonicalUrl;
    _ogTitle = ogTitle;
    _ogDescription = ogDescription;
    _ogImage = ogImage;
    _ogUrl = ogUrl;
    _ogType = ogType;
    _ogSiteName = ogSiteName;
    _ogLocale = ogLocale;
    _isActive = isActive;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
}

  EventsData.fromJson(dynamic json) {
    _id = json['id'];
    _categoryId = json['category_id'];
    _name = json['name'];
    _slug = json['slug'];
    _date = json['date'];
    _description = json['description'];
    _image = json['image'];
    _video = json['video'];
    _youtubeVideo = json['youtube_video'];
    _instagramPost = json['instagram_post'];
    _metaDescription = json['meta_description'];
    _metaKeywords = json['meta_keywords'];
    _robots = json['robots'];
    _metaAuthor = json['meta_author'];
    _canonicalUrl = json['canonical_url'];
    _ogTitle = json['og_title'];
    _ogDescription = json['og_description'];
    _ogImage = json['og_image'];
    _ogUrl = json['og_url'];
    _ogType = json['og_type'];
    _ogSiteName = json['og_site_name'];
    _ogLocale = json['og_locale'];
    _isActive = json['is_active'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }
  String? _id;
  String? _categoryId;
  String? _name;
  String? _slug;
  String? _date;
  String? _description;
  String? _image;
  String? _video;
  String? _youtubeVideo;
  String? _instagramPost;
  String? _metaDescription;
  String? _metaKeywords;
  String? _robots;
  String? _metaAuthor;
  String? _canonicalUrl;
  String? _ogTitle;
  String? _ogDescription;
  String? _ogImage;
  String? _ogUrl;
  String? _ogType;
  String? _ogSiteName;
  String? _ogLocale;
  bool? _isActive;
  String? _createdAt;
  String? _updatedAt;
EventsData copyWith({  String? id,
  String? categoryId,
  String? name,
  String? slug,
  String? date,
  String? description,
  String? image,
  String? video,
  String? youtubeVideo,
  String? instagramPost,
  String? metaDescription,
  String? metaKeywords,
  String? robots,
  String? metaAuthor,
  String? canonicalUrl,
  String? ogTitle,
  String? ogDescription,
  String? ogImage,
  String? ogUrl,
  String? ogType,
  String? ogSiteName,
  String? ogLocale,
  bool? isActive,
  String? createdAt,
  String? updatedAt,
}) => EventsData(  id: id ?? _id,
  categoryId: categoryId ?? _categoryId,
  name: name ?? _name,
  slug: slug ?? _slug,
  date: date ?? _date,
  description: description ?? _description,
  image: image ?? _image,
  video: video ?? _video,
  youtubeVideo: youtubeVideo ?? _youtubeVideo,
  instagramPost: instagramPost ?? _instagramPost,
  metaDescription: metaDescription ?? _metaDescription,
  metaKeywords: metaKeywords ?? _metaKeywords,
  robots: robots ?? _robots,
  metaAuthor: metaAuthor ?? _metaAuthor,
  canonicalUrl: canonicalUrl ?? _canonicalUrl,
  ogTitle: ogTitle ?? _ogTitle,
  ogDescription: ogDescription ?? _ogDescription,
  ogImage: ogImage ?? _ogImage,
  ogUrl: ogUrl ?? _ogUrl,
  ogType: ogType ?? _ogType,
  ogSiteName: ogSiteName ?? _ogSiteName,
  ogLocale: ogLocale ?? _ogLocale,
  isActive: isActive ?? _isActive,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
);
  String? get id => _id;
  String? get categoryId => _categoryId;
  String? get name => _name;
  String? get slug => _slug;
  String? get date => _date;
  String? get description => _description;
  String? get image => _image;
  String? get video => _video;
  String? get youtubeVideo => _youtubeVideo;
  String? get instagramPost => _instagramPost;
  String? get metaDescription => _metaDescription;
  String? get metaKeywords => _metaKeywords;
  String? get robots => _robots;
  String? get metaAuthor => _metaAuthor;
  String? get canonicalUrl => _canonicalUrl;
  String? get ogTitle => _ogTitle;
  String? get ogDescription => _ogDescription;
  String? get ogImage => _ogImage;
  String? get ogUrl => _ogUrl;
  String? get ogType => _ogType;
  String? get ogSiteName => _ogSiteName;
  String? get ogLocale => _ogLocale;
  bool? get isActive => _isActive;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['category_id'] = _categoryId;
    map['name'] = _name;
    map['slug'] = _slug;
    map['date'] = _date;
    map['description'] = _description;
    map['image'] = _image;
    map['video'] = _video;
    map['youtube_video'] = _youtubeVideo;
    map['instagram_post'] = _instagramPost;
    map['meta_description'] = _metaDescription;
    map['meta_keywords'] = _metaKeywords;
    map['robots'] = _robots;
    map['meta_author'] = _metaAuthor;
    map['canonical_url'] = _canonicalUrl;
    map['og_title'] = _ogTitle;
    map['og_description'] = _ogDescription;
    map['og_image'] = _ogImage;
    map['og_url'] = _ogUrl;
    map['og_type'] = _ogType;
    map['og_site_name'] = _ogSiteName;
    map['og_locale'] = _ogLocale;
    map['is_active'] = _isActive;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    return map;
  }

}