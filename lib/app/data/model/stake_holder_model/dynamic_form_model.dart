// models/form_field_model.dart
class DynamicFormField {
  final String key;
  final String type;
  final String label;
  final bool required;
  final int? minLength;
  final int? maxLength;
  final List<String>? options;
  final DependsOn? dependsOn;
  final int order;
  final int? min;
  final int? max;

  DynamicFormField({
    required this.key,
    required this.type,
    required this.label,
    required this.required,
    required this.order,
    this.minLength,
    this.maxLength,
    this.options,
    this.dependsOn,
    this.min,
    this.max,
  });

  factory DynamicFormField.fromJson(String key, Map<String, dynamic> json) {
    return DynamicFormField(
      key: key,
      type: json['type'],
      label: json['label'],
      required: json['required'] ?? false,
      order: json['order'],
      minLength: json['min_length'],
      maxLength: json['max_length'],
      options: json['options'] != null
          ? List<String>.from(json['options'])
          : null,
      dependsOn: json['depends_on'] != null
          ? DependsOn.fromJson(json['depends_on'])
          : null,
      min: json['min'],
      max: json['max'],
    );
  }
}

class DependsOn {
  final String field;
  final String value;

  DependsOn({required this.field, required this.value});

  factory DependsOn.fromJson(Map<String, dynamic> json) {
    return DependsOn(
      field: json['field'],
      value: json['value'],
    );
  }
}

class DynamicFormResponse {
  final String userType;
  final Map<String, DynamicFormField> fields;

  DynamicFormResponse({
    required this.userType,
    required this.fields,
  });

  factory DynamicFormResponse.fromJson(Map<String, dynamic> json) {
    final fields = <String, DynamicFormField>{};
    final fieldsData = json['fields'] as Map<String, dynamic>;

    fieldsData.forEach((key, value) {
      fields[key] = DynamicFormField.fromJson(key, value);
    });

    return DynamicFormResponse(
      userType: json['user_type'],
      fields: fields,
    );
  }
}