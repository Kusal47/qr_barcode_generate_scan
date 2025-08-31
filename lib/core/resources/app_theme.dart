import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';

class AppThemes {
  static final Color _lightFocusColor = Colors.black.withOpacity(0.12);
  static final Color _darkFocusColor = Colors.white.withOpacity(0.12);
static ThemeData lightThemeData = themeData(lightColorScheme, _lightFocusColor, Brightness.light);
static ThemeData darkThemeData = themeData(darkColorScheme, _darkFocusColor, Brightness.dark);

static ThemeData themeData(ColorScheme colorScheme, Color focusColor, Brightness brightness) {
  final isDark = brightness == Brightness.dark;

  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: colorScheme,

    // ---- COLORS ----
    primaryColor: colorScheme.primary,
    primaryColorLight: isDark ? Colors.grey.shade800 : Colors.blue.shade100,
    primaryColorDark: isDark ? Colors.black : Colors.blueGrey,
    scaffoldBackgroundColor: colorScheme.background,
    canvasColor: colorScheme.background,
    cardColor: colorScheme.surface,
    dividerColor: Colors.grey,
    focusColor: focusColor,
    splashColor: colorScheme.primary.withOpacity(0.12),
    highlightColor: Colors.transparent,

    // ---- APP BAR ----
    appBarTheme: AppBarTheme(
      backgroundColor: colorScheme.primary,
      foregroundColor: colorScheme.onPrimary,
      elevation: 0,
      systemOverlayStyle: isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
    ),

    // ---- ICONS ----
    iconTheme: IconThemeData(color: colorScheme.onBackground),
    primaryIconTheme: IconThemeData(color: colorScheme.onPrimary),

    // ---- TEXT ----
    fontFamily: GoogleFonts.ptSans().fontFamily,
    textTheme: textTheme.apply(
      bodyColor: colorScheme.onBackground,
      displayColor: colorScheme.onBackground,
    ),
    primaryTextTheme: textTheme.apply(
      bodyColor: colorScheme.onPrimary,
      displayColor: colorScheme.onPrimary,
    ),

    // ---- BUTTONS ----
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: colorScheme.primary,
        side: BorderSide(color: colorScheme.primary),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: colorScheme.secondary),
    ),

    // ---- INPUTS ----
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: colorScheme.surface,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    ),

    // ---- CARDS & DIALOGS ----
    cardTheme: CardTheme(
      color: colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    dialogTheme: DialogTheme(
      backgroundColor: colorScheme.surface,
      titleTextStyle: TextStyle(
        color: colorScheme.onSurface,
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
      contentTextStyle: TextStyle(color: colorScheme.onSurface),
    ),

    // ---- SWITCH / SLIDER / RADIO / CHECKBOX ----
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.all(colorScheme.primary),
      trackColor: MaterialStateProperty.all(colorScheme.primary.withOpacity(0.4)),
    ),
    sliderTheme: SliderThemeData(
      activeTrackColor: colorScheme.primary,
      thumbColor: colorScheme.primary,
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.resolveWith(
        (states) => states.contains(MaterialState.selected)
            ? colorScheme.primary
            : Colors.grey,
      ),
    ),
    radioTheme: RadioThemeData(
      fillColor: MaterialStateProperty.resolveWith(
        (states) => states.contains(MaterialState.selected)
            ? colorScheme.primary
            : Colors.grey,
      ),
    ),

    // ---- MISC ----
    progressIndicatorTheme: ProgressIndicatorThemeData(color: colorScheme.primary),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: colorScheme.surface,
      contentTextStyle: TextStyle(color: colorScheme.onSurface),
      actionTextColor: colorScheme.secondary,
    ),
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      textStyle: TextStyle(color: colorScheme.onSurface),
    ),
  );
}

  static const textTheme = TextTheme(
    titleLarge: TextStyle(fontSize: 15.0, color: Colors.black, height: 1.3),
    titleMedium: TextStyle(fontSize: 16.0, color: Colors.black, height: 1.3),
    titleSmall:
        TextStyle(fontSize: 17.0, fontWeight: FontWeight.w500, color: Colors.black, height: 1.3),
  );

  static const ColorScheme lightColorScheme = ColorScheme(
    primary: primaryColor,
    secondary: secondaryColor,
    background: whiteColor,
    surface: Colors.white,
    onBackground: Colors.black,
    error: Colors.red,
    onError: Colors.white,
    onPrimary: Colors.white,
    onSecondary: Colors.black,
    onSurface: primaryColor,
    brightness: Brightness.light,
  );

  static const ColorScheme darkColorScheme = ColorScheme(
    primary: primaryColor,
    secondary: secondaryColor,
    background: blackColor,
    surface: Color(0xff1E2746),
    onBackground: Colors.white,
    error: Colors.red,
    onError: Colors.white,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: Colors.white,
    brightness: Brightness.dark,
  );

}
