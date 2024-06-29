import 'package:flutter/material.dart';

class CustomColors extends ThemeExtension<CustomColors> {
  final Color red;
  final Color green;
  final Color blue;
  final Color grey;
  final Color lightGrey;
  final Color white;
  final Color separator;
  final Color overlay;
  final Color disable;

  CustomColors({
    required this.red,
    required this.green,
    required this.blue,
    required this.grey,
    required this.lightGrey,
    required this.white,
    required this.separator,
    required this.overlay,
    required this.disable,
  });

  @override
  CustomColors copyWith({
    Color? red,
    Color? green,
    Color? blue,
    Color? grey,
    Color? lightGrey,
    Color? white,
    Color? separator,
    Color? overlay,
    Color? disable,
  }) {
    return CustomColors(
      red: red ?? this.red,
      green: green ?? this.green,
      blue: blue ?? this.blue,
      grey: grey ?? this.grey,
      lightGrey: lightGrey ?? this.lightGrey,
      white: white ?? this.white,
      separator: separator ?? this.separator,
      overlay: overlay ?? this.overlay,
      disable: disable ?? this.disable,
    );
  }

  @override
  CustomColors lerp(ThemeExtension<CustomColors>? other, double t) {
    if (other is! CustomColors) return this;
    return CustomColors(
      red: Color.lerp(red, other.red, t)!,
      green: Color.lerp(green, other.green, t)!,
      blue: Color.lerp(blue, other.blue, t)!,
      grey: Color.lerp(grey, other.grey, t)!,
      lightGrey: Color.lerp(lightGrey, other.lightGrey, t)!,
      white: Color.lerp(white, other.white, t)!,
      separator: Color.lerp(separator, other.separator, t)!,
      overlay: Color.lerp(overlay, other.overlay, t)!,
      disable: Color.lerp(disable, other.disable, t)!,
    );
  }
}
