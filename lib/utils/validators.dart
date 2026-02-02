/// ========================================
/// FORM VALIDATION UTILITIES
/// Provides validation functions for forms
/// ========================================

/// Email validation
/// Returns null if valid, error message if invalid
String? validateEmail(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Email is required';
  }
  
  final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
  if (!emailRegex.hasMatch(value.trim())) {
    return 'Please enter a valid email address';
  }
  
  return null;
}

/// Password validation
/// Returns null if valid, error message if invalid
String? validatePassword(String? value, {int minLength = 8}) {
  if (value == null || value.isEmpty) {
    return 'Password is required';
  }
  
  if (value.length < minLength) {
    return 'Password must be at least $minLength characters';
  }
  
  return null;
}

/// Confirm password validation
/// Returns null if valid, error message if invalid
String? validateConfirmPassword(String? value, String password) {
  if (value == null || value.isEmpty) {
    return 'Please confirm your password';
  }
  
  if (value != password) {
    return 'Passwords do not match';
  }
  
  return null;
}

/// Required field validation
/// Returns null if valid, error message if invalid
String? validateRequired(String? value, String fieldName) {
  if (value == null || value.trim().isEmpty) {
    return '$fieldName is required';
  }
  
  return null;
}

/// Phone number validation
/// Returns null if valid, error message if invalid
String? validatePhone(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Phone number is required';
  }
  
  // Remove all non-digit characters
  final digitsOnly = value.replaceAll(RegExp(r'\D'), '');
  
  if (digitsOnly.length < 10) {
    return 'Please enter a valid phone number';
  }
  
  return null;
}

/// Username validation
/// Returns null if valid, error message if invalid
String? validateUsername(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Username is required';
  }
  
  if (value.trim().length < 3) {
    return 'Username must be at least 3 characters';
  }
  
  // Only allow alphanumeric and underscore
  final usernameRegex = RegExp(r'^[a-zA-Z0-9_]+$');
  if (!usernameRegex.hasMatch(value.trim())) {
    return 'Username can only contain letters, numbers, and underscores';
  }
  
  return null;
}

/// Password strength checker
/// Returns a PasswordStrength object with strength level and score
class PasswordStrength {
  final String level; // 'weak', 'medium', 'strong'
  final int score; // 0-6
  final double percentage; // 0.0-1.0
  
  PasswordStrength({
    required this.level,
    required this.score,
    required this.percentage,
  });
}

/// Check password strength
PasswordStrength checkPasswordStrength(String password) {
  int score = 0;
  
  // Length checks
  if (password.length >= 8) score++;
  if (password.length >= 12) score++;
  
  // Contains lowercase
  if (RegExp(r'[a-z]').hasMatch(password)) score++;
  
  // Contains uppercase
  if (RegExp(r'[A-Z]').hasMatch(password)) score++;
  
  // Contains numbers
  if (RegExp(r'[0-9]').hasMatch(password)) score++;
  
  // Contains special characters
  if (RegExp(r'[^a-zA-Z0-9]').hasMatch(password)) score++;
  
  // Determine strength level
  String level;
  double percentage;
  
  if (score >= 5) {
    level = 'strong';
    percentage = 1.0;
  } else if (score >= 3) {
    level = 'medium';
    percentage = 0.66;
  } else {
    level = 'weak';
    percentage = 0.33;
  }
  
  return PasswordStrength(
    level: level,
    score: score,
    percentage: percentage,
  );
}
