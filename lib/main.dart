import 'package:flutter/material.dart';
import 'constants/app_theme.dart';
import 'pages/login_page.dart';

/// ========================================
/// URBINO UNIVERSITY AUTHENTICATION
/// Student Housing Platform
/// ========================================

void main() {
  runApp(const UrbinoAuthApp());
}

class UrbinoAuthApp extends StatelessWidget {
  const UrbinoAuthApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Urbino Student Housing',
      debugShowCheckedModeBanner: false,
      theme: UrbinoTheme.theme,
      home: const LoginPage(),
    );
  }
}
