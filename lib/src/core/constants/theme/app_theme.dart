import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../colors/colors.dart';

class AppTheme {
  const AppTheme._();

  static final light = ThemeData(
    useMaterial3: false,
    colorScheme: const ColorScheme.light(
      primary: LightColors.labelPrimary,
      secondary: LightColors.labelSecondary,
      tertiary: LightColors.labelTertiary,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: LightColors.blue,
    ),
    scaffoldBackgroundColor: LightColors.backPrimary,
    appBarTheme: const AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark,
      ),
      backgroundColor: LightColors.backPrimary,
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w500,
      ),
      titleMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w500,
      ),
      labelMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      bodyMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      bodySmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
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
      )
    ],
  );
}
