import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Color primaryColorValue = Color(0xff14b881);

class AppTheme {
  final BuildContext context;
  late final ThemeData appTheme;

  AppTheme({required this.context}) {
    appTheme = ThemeData(
      useMaterial3: true,
      textTheme: GoogleFonts.lexendTextTheme(Theme.of(context).textTheme),
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColorValue,
        primary: primaryColorValue,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColorValue,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColorValue,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}
