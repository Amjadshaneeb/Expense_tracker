import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    primaryColor: const Color(0xFF1E88E5),
    hintColor: const Color(0xFFFFB74D),
    scaffoldBackgroundColor: Colors.white,
    textTheme: TextTheme(
      bodyLarge: GoogleFonts.roboto(
        fontWeight: FontWeight.normal,
        fontSize: 16,
        color: const Color(0xFF212121),
      ),
      bodyMedium: GoogleFonts.roboto(
        fontWeight: FontWeight.normal,
        fontSize: 14,
        color: const Color(0xFF757575),
      ),
      titleLarge: GoogleFonts.montserrat(
        fontWeight: FontWeight.bold,
        fontSize: 22,
        color: const Color(0xFF212121),
      ),
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: const Color(0xFF1E88E5), 
      textTheme: ButtonTextTheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8), 
      ),
      splashColor:
          Colors.transparent, 
      highlightColor: Colors.transparent, 
      hoverColor: const Color(0xFF1565C0), 
    ),
    dividerColor: const Color(0xFFBDBDBD),
    colorScheme: const ColorScheme(
      primary: Color(0xFF1E88E5),
      onPrimary: Colors.white,
      secondary: Color(0xFFFFB74D),
      onSecondary: Colors.black,
      surface: Colors.white,
      onSurface: Colors.black,
      error: Color(0xFFD32F2F),
      onError: Colors.white,
      brightness: Brightness.light,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    primaryColor: const Color(0xFF1E88E5),
    colorScheme: const ColorScheme(
      primary: Color(0xFF1E88E5),
      onPrimary: Colors.white,
      secondary: Color(0xFFFFB74D),
      onSecondary: Colors.black,
      surface: Color(0xFF121212),
      onSurface: Colors.white,
      error: Color(0xFFD32F2F),
      onError: Colors.white,
      brightness: Brightness.dark,
    ),
    scaffoldBackgroundColor: const Color(0xFF121212),
    textTheme: TextTheme(
      bodyLarge: GoogleFonts.roboto(
        fontWeight: FontWeight.normal,
        fontSize: 16,
        color: const Color(0xFFE0E0E0),
      ),
      bodyMedium: GoogleFonts.roboto(
        fontWeight: FontWeight.normal,
        fontSize: 14,
        color: const Color(0xFFBDBDBD),
      ),
      titleLarge: GoogleFonts.montserrat(
        fontWeight: FontWeight.bold,
        fontSize: 22,
        color: const Color(0xFFE0E0E0),
      ),
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: Color(0xFF1E88E5),
      textTheme: ButtonTextTheme.primary,
    ),
    dividerColor: const Color(0xFF757575),
    hoverColor: const Color(0xFFD32F2F),
  );
}
