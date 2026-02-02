import 'package:flutter/material.dart';

/// ========================================
/// URBINO UNIVERSITY AUTHENTICATION - THEME
/// Inspired by Renaissance architecture
/// Università degli Studi di Urbino Carlo Bo
/// ========================================

/// Urbino University color palette
/// Inspired by historical architecture and official university colors
class UrbinoColors {
  // Primary University Colors
  static const Color darkBlue =
      Color(0xFF002B5C); // Official university dark blue
  static const Color gold = Color(0xFFD1B97C); // Elegant gold/beige
  static const Color white = Color(0xFFFFFFFF); // Pure white

  // Secondary & Accent Colors
  static const Color brickOrange =
      Color(0xFFD4735E); // Urbino buildings inspiration
  static const Color lightGold =
      Color(0xFFE8D9B8); // Lighter gold for backgrounds
  static const Color deepBlue = Color(0xFF001840); // Darker blue for depth
  static const Color paleBlue = Color(0xFFE8EEF5); // Very light blue

  // Neutrals
  static const Color offWhite = Color(0xFFFAF8F5); // Warm off-white
  static const Color lightBeige = Color(0xFFF5F1E8); // Light beige background
  static const Color cream = Color(0xFFFFF9F0); // Cream for subtle backgrounds
  static const Color warmGray = Color(0xFF8B8574); // Warm gray for text
  static const Color darkGray = Color(0xFF4A4A4A); // Dark gray for primary text

  // Functional Colors
  static const Color success = Color(0xFF52A447); // Success green
  static const Color error = Color(0xFFD32F2F); // Error red
  static const Color warning = Color(0xFFE89B3C); // Warning orange

  // Dark Mode Colors
  static const Color deepNavy = Color(0xFF001229);
  static const Color darkSurface = Color(0xFF001F3D);
  static const Color darkCard = Color(0xFF00264D);
  static const Color darkBorder = Color(0xFF003366);
  static const Color mutedGold = Color(0xFFA69362);
}

/// Urbino-inspired theme configuration
class UrbinoTheme {
  /// Main app theme with Renaissance elegance
  static ThemeData get theme {
    return ThemeData(
      primaryColor: UrbinoColors.darkBlue,
      scaffoldBackgroundColor: UrbinoColors.offWhite,
      fontFamily: 'Inter', // Clean, professional font

      // Color scheme
      colorScheme: const ColorScheme(
        primary: UrbinoColors.darkBlue,
        secondary: UrbinoColors.gold,
        surface: UrbinoColors.white,
        background: UrbinoColors.offWhite,
        error: UrbinoColors.error,
        onPrimary: UrbinoColors.white,
        onSecondary: UrbinoColors.darkBlue,
        onSurface: UrbinoColors.darkGray,
        onBackground: UrbinoColors.darkGray,
        onError: UrbinoColors.white,
        brightness: Brightness.light,
      ),

      // App bar theme
      appBarTheme: const AppBarTheme(
        backgroundColor: UrbinoColors.darkBlue,
        foregroundColor: UrbinoColors.white,
        elevation: 0,
        centerTitle: true,
      ),

      // Input decoration theme - Elegant and refined
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: UrbinoColors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 18),

        // Border when enabled
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: UrbinoColors.lightGold,
            width: 1.5,
          ),
        ),

        // Border when focused
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: UrbinoColors.gold,
            width: 2,
          ),
        ),

        // Border when error
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: UrbinoColors.error,
            width: 1.5,
          ),
        ),

        // Border when focused with error
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: UrbinoColors.error,
            width: 2,
          ),
        ),

        // Label style
        labelStyle: const TextStyle(
          color: UrbinoColors.warmGray,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),

        // Floating label style
        floatingLabelStyle: const TextStyle(
          color: UrbinoColors.gold,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),

        // Error style
        errorStyle: const TextStyle(
          color: UrbinoColors.error,
          fontSize: 12,
        ),
      ),

      // Elevated button theme - Premium gradient style
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: UrbinoColors.darkBlue,
          foregroundColor: UrbinoColors.white,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
          shadowColor: UrbinoColors.darkBlue.withOpacity(0.4),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),

      // Text button theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: UrbinoColors.gold,
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  /// Dark theme for nocturnal study sessions
  static ThemeData get darkTheme {
    return ThemeData(
      primaryColor: UrbinoColors.darkBlue,
      scaffoldBackgroundColor: UrbinoColors.deepNavy,
      fontFamily: 'Inter',
      brightness: Brightness.dark,
      colorScheme: const ColorScheme(
        primary: UrbinoColors.gold,
        secondary: UrbinoColors.lightGold,
        surface: UrbinoColors.darkSurface,
        background: UrbinoColors.deepNavy,
        error: UrbinoColors.error,
        onPrimary: UrbinoColors.darkBlue,
        onSecondary: UrbinoColors.darkBlue,
        onSurface: UrbinoColors.paleBlue,
        onBackground: UrbinoColors.paleBlue,
        onError: UrbinoColors.white,
        brightness: Brightness.dark,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: UrbinoColors.deepNavy,
        foregroundColor: UrbinoColors.white,
        elevation: 0,
        centerTitle: true,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: UrbinoColors.darkSurface,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide:
              const BorderSide(color: UrbinoColors.darkBorder, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: UrbinoColors.gold, width: 2),
        ),
        labelStyle: const TextStyle(color: UrbinoColors.mutedGold),
        floatingLabelStyle: const TextStyle(color: UrbinoColors.gold),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: UrbinoColors.gold,
          foregroundColor: UrbinoColors.darkBlue,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 4,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

/// Custom text styles inspired by Italian design
class UrbinoTextStyles {
  // Heading styles
  static TextStyle heading1(BuildContext context) => TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: Theme.of(context).brightness == Brightness.dark
            ? UrbinoColors.gold
            : UrbinoColors.darkBlue,
        letterSpacing: -0.5,
        height: 1.2,
      );

  static TextStyle heading2(BuildContext context) => TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: Theme.of(context).brightness == Brightness.dark
            ? UrbinoColors.gold
            : UrbinoColors.darkBlue,
        letterSpacing: -0.3,
      );

  static TextStyle subtitle(BuildContext context) => TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: Theme.of(context).brightness == Brightness.dark
            ? UrbinoColors.mutedGold
            : UrbinoColors.warmGray,
        height: 1.5,
      );

  // Body text
  static TextStyle bodyText(BuildContext context) => TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: Theme.of(context).brightness == Brightness.dark
            ? UrbinoColors.paleBlue
            : UrbinoColors.darkGray,
        height: 1.6,
      );

  static TextStyle bodyTextBold(BuildContext context) => TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Theme.of(context).brightness == Brightness.dark
            ? UrbinoColors.white
            : UrbinoColors.darkGray,
      );

  // Label text
  static TextStyle labelText(BuildContext context) => TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: Theme.of(context).brightness == Brightness.dark
            ? UrbinoColors.gold
            : UrbinoColors.darkBlue,
        letterSpacing: 0.3,
      );

  // Small text
  static TextStyle smallText(BuildContext context) => TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: Theme.of(context).brightness == Brightness.dark
            ? UrbinoColors.mutedGold
            : UrbinoColors.warmGray,
      );

  // Link text
  static TextStyle linkText(BuildContext context) => TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: UrbinoColors.gold,
        decoration: TextDecoration.underline,
      );

  // Button text
  static TextStyle buttonText(BuildContext context) => TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Theme.of(context).brightness == Brightness.dark
            ? UrbinoColors.darkBlue
            : UrbinoColors.white,
        letterSpacing: 0.5,
      );
}

/// Elegant shadows inspired by Renaissance architecture
class UrbinoShadows {
  static const BoxShadow soft = BoxShadow(
    color: Color(0x0A000000),
    blurRadius: 8,
    offset: Offset(0, 2),
  );

  static const BoxShadow medium = BoxShadow(
    color: Color(0x14000000),
    blurRadius: 16,
    offset: Offset(0, 4),
  );

  static const BoxShadow elevated = BoxShadow(
    color: Color(0x1F000000),
    blurRadius: 24,
    offset: Offset(0, 8),
  );

  static const BoxShadow premium = BoxShadow(
    color: Color(0x29000000),
    blurRadius: 32,
    offset: Offset(0, 12),
  );

  // Colored shadows for accents
  static BoxShadow goldGlow = BoxShadow(
    color: UrbinoColors.gold.withOpacity(0.2),
    blurRadius: 20,
    offset: const Offset(0, 8),
  );

  static BoxShadow blueGlow = BoxShadow(
    color: UrbinoColors.darkBlue.withOpacity(0.15),
    blurRadius: 20,
    offset: const Offset(0, 8),
  );
}

/// Custom gradients for premium feel
class UrbinoGradients {
  // Background gradients
  static LinearGradient backgroundLight(BuildContext context) => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: Theme.of(context).brightness == Brightness.dark
            ? [UrbinoColors.deepNavy, UrbinoColors.darkSurface]
            : [
                UrbinoColors.paleBlue,
                UrbinoColors.offWhite,
                UrbinoColors.cream
              ],
      );

  static LinearGradient primaryButton(BuildContext context) =>
      const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          UrbinoColors.darkBlue,
          UrbinoColors.deepBlue,
        ],
      );

  static LinearGradient goldAccent(BuildContext context) =>
      const LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          UrbinoColors.gold,
          UrbinoColors.lightGold,
        ],
      );
}

/// Border radius constants
class UrbinoBorderRadius {
  static const double small = 12.0;
  static const double medium = 16.0;
  static const double large = 20.0;
  static const double xlarge = 24.0;
}

/// Simple Localization Manager for Frontend-only project
class UrbinoL10n {
  static String currentLanguage = 'en';

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'app_title': 'Urbino Housing',
      'welcome': 'Welcome to Urbino',
      'subtitle': 'Find your home near university',
      'search_hint': 'Search properties...',
      'categories': 'Categories',
      'ai_assistant': 'AI Assistant',
      'roommate_matcher': 'Roommates',
      'uni_integration': 'University Life',
      'payments': 'Payments',
      'favorites': 'Favorites',
      'dark_mode': 'Dark Mode',
      'language': 'Language',
      'logout': 'Logout',
      'all': 'All Properties',
      'studios': 'Studios',
      'apartments': 'Apartments',
      'rooms': 'Rooms',
      'luxury': 'Luxury',
      'need_help': 'Need Help?',
      'support_msg': 'Contact our support team',
    },
    'it': {
      'app_title': 'Alloggi Urbino',
      'welcome': 'Benvenuti a Urbino',
      'subtitle': 'Trova casa vicino all\'università',
      'search_hint': 'Cerca alloggi...',
      'categories': 'Categorie',
      'ai_assistant': 'Assistente AI',
      'roommate_matcher': 'Coinquilini',
      'uni_integration': 'Vita Universitaria',
      'payments': 'Pagamenti',
      'favorites': 'Preferiti',
      'dark_mode': 'Modalità Scura',
      'language': 'Lingua',
      'logout': 'Esci',
      'all': 'Tutti gli Immobili',
      'studios': 'Monolocali',
      'apartments': 'Appartamenti',
      'rooms': 'Stanze',
      'luxury': 'Lusso',
      'need_help': 'Hai bisogno di aiuto?',
      'support_msg': 'Contatta il nostro team',
    },
    'ar': {
      'app_title': 'سكن طلاب أوربينو',
      'welcome': 'مرحباً بك في أوربينو',
      'subtitle': 'ابحث عن سكنك بالقرب من الجامعة',
      'search_hint': 'ابحث عن العقارات...',
      'categories': 'الفئات',
      'ai_assistant': 'مساعد AI',
      'roommate_matcher': 'شريك السكن',
      'uni_integration': 'الحياة الجامعية',
      'payments': 'المدفوعات',
      'favorites': 'المفضلات',
      'dark_mode': 'الوضع المظلم',
      'language': 'اللغة',
      'logout': 'تسجيل الخروج',
      'all': 'كل العقارات',
      'studios': 'استوديو',
      'apartments': 'شقق',
      'rooms': 'غرف',
      'luxury': 'فاخر',
      'need_help': 'هل تحتاج مساعدة؟',
      'support_msg': 'اتصل بفريق الدعم لدينا',
    },
  };

  static String translate(String key) {
    return _localizedValues[currentLanguage]?[key] ?? key;
  }
}
