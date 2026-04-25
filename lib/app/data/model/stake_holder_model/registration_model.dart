class RegistrationModel {
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
  String? password;
  String? referenceNumber;
  String? objective;
  List<String>? category;
  String? customCategory;
  List<String>? subCategory;
  String? customSubCategory;
  String? describeYourNeed;

  /// Dynamic fields
  Map<String, dynamic> extraFields;

  RegistrationModel({
    this.fullName,
    this.email,
    this.phoneNumber,
    this.address,
    this.city,
    this.state,
    this.latitude,
    this.longitude,
    this.aboutYourself,
    this.userType = 'student',
    this.password,
    this.referenceNumber,
    this.objective = 'Personal networking',
    this.category,
    this.customCategory,
    this.subCategory,
    this.customSubCategory,
    this.describeYourNeed,
    Map<String, dynamic>? extraFields,
  }) : extraFields = extraFields ?? {};

  // ---------- Dynamic fields ----------
  void setExtraField(String key, dynamic value) {
    extraFields[key] = value;
  }

  dynamic getExtraField(String key) {
    return extraFields[key];
  }

  // ---------- To JSON ----------
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
      'password': password,
      'reference_number': referenceNumber,
      'objective': objective,
      'category': category,
      'custom_category': customCategory?.trim().isEmpty == true
          ? null
          : customCategory,
      'sub_category': subCategory,
      'custom_sub_category': customSubCategory?.trim().isEmpty == true
          ? null
          : customSubCategory,
      'describe_your_need': describeYourNeed,
      ...extraFields, // merge dynamic fields
    };
  }

/// Copy helper
  RegistrationModel copyWith({
    String? fullName,
    String? email,
    String? phoneNumber,
    String? address,
    String? city,
    String? state,
    double? latitude,
    double? longitude,
    String? aboutYourself,
    String? userType,
    String? password,
    String? referenceNumber,
    String? objective,
    List<String>? category,
    String? customCategory,
    List<String>? subCategory,
    String? customSubCategory,
    String? describeYourNeed,
    Map<String, dynamic>? extraFields,
  }) {
    return RegistrationModel(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      aboutYourself: aboutYourself ?? this.aboutYourself,
      userType: userType ?? this.userType,
      password: password ?? this.password,
      referenceNumber: referenceNumber ?? this.referenceNumber,
      objective: objective ?? this.objective,
      category: category ?? this.category,
      customCategory: customCategory ?? this.customCategory,
      subCategory: subCategory ?? this.subCategory,
      customSubCategory: customSubCategory ?? this.customSubCategory,
      describeYourNeed: describeYourNeed ?? this.describeYourNeed,
      extraFields: extraFields ?? this.extraFields,
    );
  }
}
