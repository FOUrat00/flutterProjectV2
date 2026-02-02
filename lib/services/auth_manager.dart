import 'package:flutter/material.dart';

class AuthUser {
  final String fullName;
  final String email;
  final String password;

  AuthUser({
    required this.fullName,
    required this.email,
    required this.password,
  });
}

class AuthManager {
  static final AuthManager _instance = AuthManager._internal();
  factory AuthManager() => _instance;
  AuthManager._internal() {
    // Add a default user
    _users.add(AuthUser(
      fullName: 'Student User',
      email: 'student@urbino.it',
      password: 'password123',
    ));
  }

  final List<AuthUser> _users = [];

  bool register(String fullName, String email, String password) {
    if (_users.any((u) => u.email == email)) {
      return false; // User already exists
    }
    _users.add(AuthUser(fullName: fullName, email: email, password: password));
    return true;
  }

  AuthUser? login(String email, String password) {
    try {
      return _users.firstWhere(
        (u) => u.email == email && u.password == password,
      );
    } catch (e) {
      return null;
    }
  }

  bool userExists(String email) {
    return _users.any((u) => u.email == email);
  }
}
