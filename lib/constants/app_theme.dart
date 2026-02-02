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
  static const Color darkBlue = Color(0xFF002B5C); // Official university dark blue
  static const Color gold = Color(0xFFD1B97C); // Elegant gold/beige
  static const Color white = Color(0xFFFFFFFF); // Pure white
  
  // Secondary & Accent Colors
  static const Color brickOrange = Color(0xFFD4735E); // Urbino buildings inspiration
  static const Color lightGold = Color(0xFFE8D9B8); // Lighter gold for backgrounds
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
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        
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
}

/// Custom text styles inspired by Italian design
class UrbinoTextStyles {
  // Heading styles
  static const TextStyle heading1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: UrbinoColors.darkBlue,
    letterSpacing: -0.5,
    height: 1.2,
  );
  
  static const TextStyle heading2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: UrbinoColors.darkBlue,
    letterSpacing: -0.3,
  );
  
  static const TextStyle subtitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: UrbinoColors.warmGray,
    height: 1.5,
  );
  
  // Body text
  static const TextStyle bodyText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: UrbinoColors.darkGray,
    height: 1.6,
  );
  
  static const TextStyle bodyTextBold = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: UrbinoColors.darkGray,
  );
  
  // Label text
  static const TextStyle labelText = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: UrbinoColors.darkBlue,
    letterSpacing: 0.3,
  );
  
  // Button text
  static const TextStyle buttonText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: UrbinoColors.white,
    letterSpacing: 0.5,
  );
  
  // Link text
  static const TextStyle linkText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: UrbinoColors.gold,
    decoration: TextDecoration.none,
  );
  
  // Small text
  static const TextStyle smallText = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: UrbinoColors.warmGray,
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
  static const LinearGradient backgroundLight = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      UrbinoColors.paleBlue,
      UrbinoColors.offWhite,
      UrbinoColors.cream,
    ],
  );
  
  static const LinearGradient primaryButton = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      UrbinoColors.darkBlue,
      UrbinoColors.deepBlue,
    ],
  );
  
  static const LinearGradient goldAccent = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      UrbinoColors.gold,
      UrbinoColors.lightGold,
    ],
  );
  
  // Subtle overlay for cards
  static LinearGradient cardOverlay = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      UrbinoColors.white,
      UrbinoColors.white.withOpacity(0.95),
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
