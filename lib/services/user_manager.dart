import 'dart:typed_data';
import 'package:flutter/material.dart';

class UserManager extends ChangeNotifier {
  static final UserManager _instance = UserManager._internal();
  factory UserManager() => _instance;
  UserManager._internal();

  String _name = 'Student User';
  String _email = 'student@urbino.it';
  String _phone = '+39 333 123 4567';
  String _bio =
      'International student at the University of Urbino. Love art and coffee.';

  // For web compatibility, we store the image bytes or the network URL
  Uint8List? _profileImageBytes;
  String? _profileImageUrl =
      'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=200';

  String get name => _name;
  String get email => _email;
  String get phone => _phone;
  String get bio => _bio;
  Uint8List? get profileImageBytes => _profileImageBytes;
  String? get profileImageUrl => _profileImageUrl;

  void updateProfile({
    String? name,
    String? email,
    String? phone,
    String? bio,
    Uint8List? imageBytes,
    String? imageUrl,
  }) {
    if (name != null) _name = name;
    if (email != null) _email = email;
    if (phone != null) _phone = phone;
    if (bio != null) _bio = bio;
    if (imageBytes != null) {
      _profileImageBytes = imageBytes;
      _profileImageUrl = null; // Clear URL if we have local bytes
    } else if (imageUrl != null) {
      _profileImageUrl = imageUrl;
      _profileImageBytes = null; // Clear bytes if we have a URL
    }
    notifyListeners();
  }
}
