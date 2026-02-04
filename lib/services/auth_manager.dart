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
    _users.add(AuthUser(
      fullName: 'Student User',
      email: 'student@urbino.it',
      password: 'password123',
    ));

    _loadLoginState();
  }

  final List<AuthUser> _users = [];
  bool _isLoggedIn = false;
  String? _currentUserEmail;

  bool get isLoggedIn => _isLoggedIn;
  String? get currentUserEmail => _currentUserEmail;

  Future<void> _loadLoginState() async {
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
      return false;
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
      await _saveLoginState(true, user.email);
      _isLoggedIn = true;
      _currentUserEmail = user.email;

      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> logout() async {
    _isLoggedIn = false;
    _currentUserEmail = null;
    await _saveLoginState(false, null);

    notifyListeners();
  }

  bool userExists(String email) {
    return _users.any((u) => u.email == email);
  }
}
