class BlogResponse {
  BlogResponse({
      bool? status, 
      String? message, 
      List<BlogListData>? data,}){
    _status = status;
    _message = message;
    _data = data;
}

  BlogResponse.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(BlogListData.fromJson(v));
      });
    }
  }
  bool? _status;
  String? _message;
  List<BlogListData>? _data;
BlogResponse copyWith({  bool? status,
  String? message,
  List<BlogListData>? data,
}) => BlogResponse(  status: status ?? _status,
  message: message ?? _message,
  data: data ?? _data,
);
  bool? get status => _status;
  String? get message => _message;
  List<BlogListData>? get data => _data;

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

class BlogListData {
  BlogListData({
      String? id, 
      String? title, 
      String? slug, 
      String? image, 
      String? video, 
      String? subTitle, 
      String? details, 
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
    _title = title;
    _slug = slug;
    _image = image;
    _video = video;
    _subTitle = subTitle;
    _details = details;
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

  BlogListData.fromJson(dynamic json) {
    _id = json['id'];
    _title = json['title'];
    _slug = json['slug'];
    _image = json['image'];
    _video = json['video'];
    _subTitle = json['sub_title'];
    _details = json['details'];
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
  String? _title;
  String? _slug;
  String? _image;
  String? _video;
  String? _subTitle;
  String? _details;
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
BlogListData copyWith({  String? id,
  String? title,
  String? slug,
  String? image,
  String? video,
  String? subTitle,
  String? details,
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
}) => BlogListData(  id: id ?? _id,
  title: title ?? _title,
  slug: slug ?? _slug,
  image: image ?? _image,
  video: video ?? _video,
  subTitle: subTitle ?? _subTitle,
  details: details ?? _details,
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
  String? get title => _title;
  String? get slug => _slug;
  String? get image => _image;
  String? get video => _video;
  String? get subTitle => _subTitle;
  String? get details => _details;
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
    map['title'] = _title;
    map['slug'] = _slug;
    map['image'] = _image;
    map['video'] = _video;
    map['sub_title'] = _subTitle;
    map['details'] = _details;
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