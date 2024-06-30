import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../colors/colors.dart';

class AppTheme {
  const AppTheme._();

  static final light = ThemeData(
    useMaterial3: false,
    fontFamily: "Roboto",
    scaffoldBackgroundColor: LightColors.backPrimary,
    appBarTheme: const AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.dark),
      backgroundColor: LightColors.backPrimary,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: LightColors.blue,
    ),
    colorScheme: const ColorScheme.light(
      primary: LightColors.labelPrimary,
      secondary: LightColors.labelSecondary,
      tertiary: LightColors.labelTertiary,
      background: LightColors.backPrimary,
      secondaryContainer: LightColors.backSecondary,
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),
      titleMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      labelMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
      bodyMedium: TextStyle(
        fontSize: 16,
      ),
      bodySmall: TextStyle(
        fontSize: 14,
        color: LightColors.labelTertiary,
      ),
    ),
    extensions: [
      CustomColors(
        red: LightColors.red,
        green: LightColors.green,
        blue: LightColors.blue,
        grey: LightColors.grey,
        lightGrey: LightColors.lightGrey,
        white: LightColors.white,
        separator: LightColors.supportSeparator,
        overlay: LightColors.supportOverlay,
        disable: LightColors.labelDisable,
      )
    ],
  );

  static final dark = ThemeData(
    useMaterial3: false,
    fontFamily: "Roboto",
    scaffoldBackgroundColor: DarkColors.backPrimary,
    appBarTheme: const AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.light),
      backgroundColor: DarkColors.backPrimary,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: DarkColors.blue,
    ),
    colorScheme: const ColorScheme.dark(
      primary: DarkColors.labelPrimary,
      secondary: DarkColors.labelSecondary,
      tertiary: DarkColors.labelTertiary,
      background: DarkColors.backPrimary,
      secondaryContainer: DarkColors.backSecondary,
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),
      titleMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      labelMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
      bodyMedium: TextStyle(
        fontSize: 16,
      ),
      bodySmall: TextStyle(
        fontSize: 14,
        color: DarkColors.labelTertiary,
      ),
    ),
    extensions: [
      CustomColors(
        red: DarkColors.red,
        green: DarkColors.green,
        blue: DarkColors.blue,
        grey: DarkColors.grey,
        lightGrey: DarkColors.lightGrey,
        white: DarkColors.white,
        separator: DarkColors.supportSeparator,
        overlay: DarkColors.supportOverlay,
        disable: DarkColors.labelDisable,
      )
    ],
  );
}
