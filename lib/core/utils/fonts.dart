import 'package:chat_application/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class Fonts {
  static TextStyle semiBoldTextStyle({
    double? fontSize,
    Color? color,
    TextDecoration? textDecoration,
  }) {
    return TextStyle(
      fontSize: fontSize ?? 16,
      fontWeight: FontWeight.w600,
      color: color,
      decoration: textDecoration,
      decorationThickness: 1.5,
      decorationColor: color ?? AppTheme.primaryColor,
    );
  }

  static TextStyle boldTextStyle({
    double? fontSize,
    Color? color,
    TextDecoration? textDecoration,
  }) {
    return TextStyle(
      decoration: textDecoration,
      decorationColor: color ?? AppTheme.primaryColor,
      decorationThickness: 1.5,
      fontSize: fontSize ?? 18,
      fontWeight: FontWeight.bold,
      color: color,
      letterSpacing: 1,
    );
  }

  static TextStyle regularTextStyle({
    double? fontSize,
    Color? color,
    TextDecoration? textDecoration,
  }) {
    return TextStyle(
      decoration: textDecoration,
      decorationColor: color ?? AppTheme.primaryColor,
      decorationThickness: 1.5,
      fontSize: fontSize ?? 14,
      fontWeight: FontWeight.normal,
      color: color,
    );
  }
}
