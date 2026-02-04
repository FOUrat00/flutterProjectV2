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

String? validatePassword(String? value, {int minLength = 8}) {
  if (value == null || value.isEmpty) {
    return 'Password is required';
  }

  if (value.length < minLength) {
    return 'Password must be at least $minLength characters';
  }

  return null;
}

String? validateConfirmPassword(String? value, String password) {
  if (value == null || value.isEmpty) {
    return 'Please confirm your password';
  }

  if (value != password) {
    return 'Passwords do not match';
  }

  return null;
}

String? validateRequired(String? value, String fieldName) {
  if (value == null || value.trim().isEmpty) {
    return '$fieldName is required';
  }

  return null;
}

String? validatePhone(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Phone number is required';
  }

  final digitsOnly = value.replaceAll(RegExp(r'\D'), '');

  if (digitsOnly.length < 10) {
    return 'Please enter a valid phone number';
  }

  return null;
}

String? validateUsername(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Username is required';
  }

  if (value.trim().length < 3) {
    return 'Username must be at least 3 characters';
  }

  final usernameRegex = RegExp(r'^[a-zA-Z0-9_]+$');
  if (!usernameRegex.hasMatch(value.trim())) {
    return 'Username can only contain letters, numbers, and underscores';
  }

  return null;
}

class PasswordStrength {
  final String level;
  final int score;
  final double percentage;

  PasswordStrength({
    required this.level,
    required this.score,
    required this.percentage,
  });
}

PasswordStrength checkPasswordStrength(String password) {
  int score = 0;

  if (password.length >= 8) score++;
  if (password.length >= 12) score++;

  if (RegExp(r'[a-z]').hasMatch(password)) score++;

  if (RegExp(r'[A-Z]').hasMatch(password)) score++;

  if (RegExp(r'[0-9]').hasMatch(password)) score++;

  if (RegExp(r'[^a-zA-Z0-9]').hasMatch(password)) score++;

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
