import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

const Color bluishClr = Color(0xFF4bb4e6);
const Color yellowClr = Color(0xFFFFD200);
const Color pinkClr = Color(0xFFCD3C14);
const Color white = Colors.white;
const Color primaryClr = Color(0xFFf16e00);
const Color darkGreyClr = Colors.black;
const Color darkHeaderClr = Color(0xFFEEEFFF);

class Themes {
  static final light = ThemeData(
    primaryColor: primaryClr,
    brightness: Brightness.light,
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryClr,
    ),
    colorScheme: ColorScheme.light(
      primary: primaryClr,
      secondary: primaryClr,
      onPrimary: Colors.white, // Text color on primary color
      onSecondary: Colors.white, // Text color on secondary color
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryClr, // Button background color
        foregroundColor: Colors.white, // Button text color
      ),
    ),
    sliderTheme: SliderThemeData(
      activeTrackColor: primaryClr,
      thumbColor: primaryClr,
      overlayColor: primaryClr.withOpacity(0.2),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.all(primaryClr),
      trackColor: MaterialStateProperty.all(primaryClr.withOpacity(0.5)),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.all(primaryClr),
    ),
    radioTheme: RadioThemeData(
      fillColor: MaterialStateProperty.all(primaryClr),
    ),
  );

  static final dark = ThemeData(
    primaryColor: darkGreyClr,
    brightness: Brightness.dark,
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryClr,
    ),
    colorScheme: ColorScheme.dark(
      primary: primaryClr,
      secondary: primaryClr,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryClr,
        foregroundColor: Colors.white,
      ),
    ),
    sliderTheme: SliderThemeData(
      activeTrackColor: primaryClr,
      thumbColor: primaryClr,
      overlayColor: primaryClr.withOpacity(0.2),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.all(primaryClr),
      trackColor: MaterialStateProperty.all(primaryClr.withOpacity(0.5)),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.all(primaryClr),
    ),
    radioTheme: RadioThemeData(
      fillColor: MaterialStateProperty.all(primaryClr),
    ),
  );
}

TextStyle get subHeadingStyle {
  return GoogleFonts.lato(
    textStyle: const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.grey,
    ),
  );
}

TextStyle get headingStyle {
  return GoogleFonts.lato(
    textStyle: const TextStyle(
      fontSize: 26,
      fontWeight: FontWeight.bold,
    ),
  );
}

TextStyle get titleStyle {
  return GoogleFonts.lato(
    textStyle: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: Get.isDarkMode ? Colors.white : Colors.black,
    ),
  );
}

TextStyle get subTitleStyle {
  return GoogleFonts.lato(
    textStyle: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: Get.isDarkMode ? Colors.grey[100] : Colors.grey[800],
    ),
  );
}
