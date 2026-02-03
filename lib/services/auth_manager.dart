import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

class AuthManager extends ChangeNotifier {
  static final AuthManager _instance = AuthManager._internal();
  factory AuthManager() => _instance;

  AuthManager._internal() {
    // Add a default user
    _users.add(AuthUser(
      fullName: 'Student User',
      email: 'student@urbino.it',
      password: 'password123',
    ));
    // Load login state
    _loadLoginState();
  }

  final List<AuthUser> _users = [];
  bool _isLoggedIn = false;
  String? _currentUserEmail;

  bool get isLoggedIn => _isLoggedIn;
  String? get currentUserEmail => _currentUserEmail;

  Future<void> _loadLoginState() async {
    // V3: Data Persistence (SharedPreferences)
    try {
      final prefs = await SharedPreferences.getInstance();
      _isLoggedIn = prefs.getBool('is_logged_in') ?? false;
      _currentUserEmail = prefs.getString('current_user_email');
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading login state: $e');
    }
  }

  Future<void> _saveLoginState(bool loggedIn, String? email) async {
    // V3: Data Persistence (SharedPreferences)
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_logged_in', loggedIn);
      if (email != null) {
        await prefs.setString('current_user_email', email);
      } else {
        await prefs.remove('current_user_email');
      }
    } catch (e) {
      debugPrint('Error saving login state: $e');
    }
  }

  bool register(String fullName, String email, String password) {
    if (_users.any((u) => u.email == email)) {
      return false; // User already exists
    }
    _users.add(AuthUser(fullName: fullName, email: email, password: password));
    notifyListeners();
    return true;
  }

  Future<bool> login(String email, String password) async {
    try {
      final user = _users.firstWhere(
        (u) => u.email == email && u.password == password,
      );
      _isLoggedIn = true;
      _currentUserEmail = user.email;
      await _saveLoginState(true, user.email); // Persist login
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> logout() async {
    _isLoggedIn = false;
    _currentUserEmail = null;
    await _saveLoginState(false, null); // Persist logout
    notifyListeners();
  }

  bool userExists(String email) {
    return _users.any((u) => u.email == email);
  }
}
