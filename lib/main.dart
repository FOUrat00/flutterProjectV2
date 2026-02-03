import 'package:flutter/material.dart';
import 'constants/app_theme.dart';
import 'models/property.dart';
import 'pages/login_page.dart';
import 'pages/signup_page.dart';
import 'pages/register_page.dart';
import 'pages/home_page.dart';
import 'pages/profile_settings_page.dart';
import 'pages/roommate_matcher_page.dart';
import 'pages/favorites_page.dart';
import 'pages/ai_assistant_page.dart';
import 'pages/notifications_page.dart';
import 'pages/payments_page.dart';
import 'pages/university_page.dart';
import 'pages/property_details_page.dart';
import 'pages/reservation_page.dart';

/// ========================================
/// URBINO UNIVERSITY AUTHENTICATION
/// Student Housing Platform
/// ========================================

import 'package:provider/provider.dart';
import 'services/auth_manager.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthManager()),
      ],
      child: const UrbinoAuthApp(),
    ),
  );
}

class UrbinoAuthApp extends StatefulWidget {
  const UrbinoAuthApp({Key? key}) : super(key: key);

  static _UrbinoAuthAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_UrbinoAuthAppState>();

  @override
  State<UrbinoAuthApp> createState() => _UrbinoAuthAppState();
}

class _UrbinoAuthAppState extends State<UrbinoAuthApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  void setLanguage(String lang) {
    setState(() {
      UrbinoL10n.currentLanguage = lang;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: UrbinoL10n.translate('app_title'),
      debugShowCheckedModeBanner: false,
      theme: UrbinoTheme.theme,
      darkTheme: UrbinoTheme.darkTheme,
      themeMode: _themeMode,
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignUpPage(),
        '/register': (context) => const RegisterPage(),
        '/home': (context) => const HomePage(),
        '/profile_settings': (context) => const ProfileSettingsPage(),
        '/roommate_matcher': (context) => const RoommateMatcherPage(),
        '/favorites': (context) => const FavoritesPage(),
        '/ai_assistant': (context) => const AIAssistantPage(),
        '/notifications': (context) => const NotificationsPage(),
        '/payments': (context) => const PaymentsPage(),
        '/university': (context) => const UniversityPage(),
        '/property_details': (context) {
          final property =
              ModalRoute.of(context)!.settings.arguments as Property;
          return PropertyDetailsPage(property: property);
        },
        '/reservation': (context) {
          final property =
              ModalRoute.of(context)!.settings.arguments as Property;
          return ReservationPage(property: property);
        },
      },
    );
  }
}
