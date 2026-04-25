class GetProfileModel {
  final bool? status;
  final String? message;
  final ProfileData? data;

  GetProfileModel({
    this.status,
    this.message,
    this.data,
  });

  factory GetProfileModel.fromJson(Map<String, dynamic> json) {
    return GetProfileModel(
      status: json['status'],
      message: json['message'],
      data: json['data'] != null
          ? ProfileData.fromJson(json['data'])
          : null,
    );
  }
}


class ProfileData {
   String? id;

  String? fullName;
  String? email;
  String? phoneNumber;
   String? address;
  String? city;
  String? state;

  double? latitude;
  double? longitude;

  String? aboutYourself;
  String? userType;
  String? referenceNumber;
  String? objective;

  List<String>? category;
  String? customCategory;

  List<String>? subCategory;
  String? customSubCategory;

  String? describeYourNeed;
  String? collegeName;
  String? degree;
  String? specialization;
  String? keySkills;
  String? experienceProjects;
  String? preferredMode;

   bool? isActive;
  bool? isVerified;
  String? paymentStatus;
  String? profilePhotoUrl;
  DateTime? createdAt;

  /// 🔥 Dynamic user-type-specific fields
  Map<String, dynamic> extraFields;

  ProfileData({
     this.id,
    this.fullName,
    this.email,
    this.phoneNumber,
     this.address,
    this.city,
    this.state,
    this.latitude,
    this.longitude,
    this.aboutYourself,
    this.userType,
    this.referenceNumber,
    this.objective,
    this.category,
    this.customCategory,
    this.subCategory,
    this.customSubCategory,
    this.describeYourNeed,
    this.isActive,
    this.isVerified,
    this.paymentStatus,
    this.profilePhotoUrl,
    this.createdAt,
    this.collegeName,
    this.degree,
    this.specialization,
    this.keySkills,
    this.experienceProjects,
    this.preferredMode,
    Map<String, dynamic>? extraFields,
  }) : extraFields = extraFields ?? {};

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    final knownKeys = {
      'id',
      'full_name',
      'email',
      'phone_number',
      'address',
      'city',
      'state',
      'latitude',
      'longitude',
      'about_yourself',
      'user_type',
      'reference_number',
      'objective',
      'category',
      'custom_category',
      'sub_category',
      'custom_sub_category',
      'describe_your_need',
      'is_active',
      'is_verified',
      'payment_status',
      'profile_photo_url',
      'created_at',
      'college_mame',
      'degree',
      'specialization',
      'key_skills',
      'experience_projects',
      'preferred_mode',
    };

    final Map<String, dynamic> extra = {};

    json.forEach((key, value) {
      if (!knownKeys.contains(key)) {
        extra[key] = value;
      }
    });

    return ProfileData(
      id: json['id'] ?? '',
      fullName: json['full_name'],
      email: json['email'],
      phoneNumber: json['phone_number'],
      address: json['address'] ?? '',
      city: json['city'],
      state: json['state'],

      latitude: json['latitude'] != null
          ? double.tryParse(json['latitude'].toString())
          : null,
      longitude: json['longitude'] != null
          ? double.tryParse(json['longitude'].toString())
          : null,

      aboutYourself: json['about_yourself'],
      userType: json['user_type'],
      referenceNumber: json['reference_number'],
      objective: json['objective'],

      category: json['category'] != null
          ? List<String>.from(json['category'])
          : null,

      customCategory: json['custom_category'],

      subCategory: json['sub_category'] != null
          ? List<String>.from(json['sub_category'])
          : null,

      customSubCategory: json['custom_sub_category'],

      describeYourNeed: json['describe_your_need'],

      isActive: json['is_active'],
      isVerified: json['is_verified'],
      paymentStatus: json['payment_status'],
      profilePhotoUrl: json['profile_photo_url'],
        collegeName: json['college_name'],
        degree: json['degree'],
        specialization: json['specialization'],
        keySkills: json['key_skills'],
        experienceProjects: json['experience_projects'],
        preferredMode: json['preferred_mode'],

      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,

      extraFields: extra,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'full_name': fullName,
      'email': email,
      'phone_number': phoneNumber,
      'address': address,
      'city': city,
      'state': state,
      'latitude': latitude,
      'longitude': longitude,
      'about_yourself': aboutYourself,
      'user_type': userType,
      'reference_number': referenceNumber,
      'objective': objective,
      'category': category,
      'custom_category': customCategory,
      'sub_category': subCategory,
      'custom_sub_category': customSubCategory,
      'describe_your_need': describeYourNeed,
      'college_name' : collegeName,
      'degree' : degree,
      'specialization' : specialization,
      'key_skills' : keySkills,
      'experience_projects' : experienceProjects,
      'preferred_mode' : preferredMode,
      ...extraFields, // 🔥 dynamic merge
    };
  }
}
class FormFieldSchema {
  final String key;
  final String label;
  final String type;

  // optional / conditional fields
  final List<String>? options;
  final List<String>? visibleFor;
  final String? dependsOn;
  final dynamic showWhen;
  final bool required;

  FormFieldSchema({
    required this.key,
    required this.label,
    required this.type,
    this.options,
    this.visibleFor,
    this.dependsOn,
    this.showWhen,
    this.required = false,
  });

  factory FormFieldSchema.fromJson(Map<String, dynamic> json) {
    return FormFieldSchema(
      key: json['key'],
      label: json['label'],
      type: json['type'],
      options: json['options'] != null
          ? List<String>.from(json['options'])
          : null,
      visibleFor: json['visible_for'] != null
          ? List<String>.from(json['visible_for'])
          : null,
      dependsOn: json['depends_on'],
      showWhen: json['show_when'],
      required: json['required'] ?? false,
    );
  }
}

