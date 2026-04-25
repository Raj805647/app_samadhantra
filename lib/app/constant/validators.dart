class Validators {
  // Email validator
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  // Password validator (example)
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  // Generic required field validator
  static String? requiredField(
      String? value, {
        String fieldName = 'Field',
        int minLength = 20,
      }) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }

    final text = value.trim();

    if (text.length < minLength) {
      return '$fieldName must be at least $minLength characters';
    }

    return null; // ✅ valid, unlimited max length
  }


  static String? confirmPassword(String? value, String? originalPassword) {
    if (value == null || value.trim().isEmpty) {
      return 'Please confirm your password';
    }

    if (value != originalPassword) {
      return 'Passwords do not match';
    }

    return null;
  }

  // ✅ Phone number validator
  static String? mobile(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your mobile number';
    }

    // ✅ Remove spaces if any
    final phone = value.trim();

    // ✅ Must be exactly 10 digits
    if (!RegExp(r'^[0-9]{10}$').hasMatch(phone)) {
      return 'Enter a valid 10-digit mobile number';
    }

    return null; // ✅ Valid number
  }

  // ✅ Name validator
  static String? name(String? value, {String fieldName = "Name"}) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your $fieldName';
    }

    final name = value.trim();

    // ✅ Optional: Allow only letters & spaces
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(name)) {
      return '$fieldName should contain only letters';
    }

    // ✅ Optional: Minimum 2 characters
    if (name.length < 2) {
      return '$fieldName must be at least 2 characters long';
    }

    return null; // ✅ Valid
  }


}
