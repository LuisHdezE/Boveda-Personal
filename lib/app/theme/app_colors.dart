import 'package:flutter/material.dart';

abstract final class AppColors {
  static const background = Color(0xFF091421);
  static const surfaceLowest = Color(0xFF050F1C);
  static const surfaceLow = Color(0xFF121C2A);
  static const surface = Color(0xFF16202E);
  static const surfaceVariant = Color(0xFF212B39); // Similar to surfaceHigh
  static const surfaceHigh = Color(0xFF212B39);
  static const surfaceHighest = Color(0xFF2B3544);
  static const surfaceContainerLowest = Color(0xFF050F1C); // Map to surfaceLowest
  static const surfaceContainerLow = Color(0xFF0F1824);
  static const surfaceContainer = Color(0xFF16202E); // Map to surface
  static const surfaceContainerHigh = Color(0xFF252E3B);

  static const onSurface = Color(0xFFD9E3F6);
  static const onSurfaceVariant = Color(0xFFC4C7C7);
  static const outline = Color(0xFF8E9192);
  static const outlineVariant = Color(0xFF444748);

  static const wealth = Color(0xFFE9C349);
  static const secondary = Color(0xFFBBC7DB);
  static const tertiary = Color(0xFFD6BEE1);
  static const income = Color(0xFF4EDEA3);
  static const expense = Color(0xFFFFB4AB);
  static const error = Color(0xFFFFB4AB); // Map to expense
  static const information = Color(0xFF0EA5E9);
}
