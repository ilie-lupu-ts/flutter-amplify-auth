import 'package:flutter/material.dart';
import 'package:flutter_amplify_auth/design/constants/colors.dart';

final defaultLightTheme = ThemeData(
  colorScheme: ColorScheme.light(
    primary: ColorPalette.black,
    secondary: ColorPalette.purple60,
    surface: Colors.white,
    background: Colors.white,
    error: ColorPalette.red60,
    onPrimary: Colors.white,
    onSecondary: Colors.black,
    onSurface: Colors.black,
    onBackground: Colors.black,
    onError: Colors.white,
  ),
  useMaterial3: true,
);

final lightThemeColors = AppColors(
  brand: BrandColors(primary: ColorPalette.purple60, secondary: ColorPalette.purple60),
  font: FontColors(
    primary: ColorPalette.neutral100,
    secondary: ColorPalette.neutral90,
    tertiary: ColorPalette.neutral80,
    disabled: ColorPalette.neutral80,
    interactive: ColorPalette.purple80,
    active: ColorPalette.neutral100,
    info: const Color(0xFF1d2530),
    warning: ColorPalette.orange90,
    error: ColorPalette.red60,
    success: ColorPalette.neutral80,
  ),
  background: BackgroundColors(
    primary: ColorPalette.white,
    secondary: ColorPalette.neutral10,
    tertiary: ColorPalette.neutral20,
    disabled: ColorPalette.neutral20,
    info: ColorPalette.blue20,
    warning: ColorPalette.orange20,
    error: const Color(0xffffebec),
    success: ColorPalette.green20,
  ),
  border: BorderColors(
    primary: ColorPalette.neutral60,
    secondary: ColorPalette.neutral40,
    tertiary: ColorPalette.neutral20,
    disabled: ColorPalette.neutral20,
    focus: ColorPalette.purple100,
    error: ColorPalette.red80,
  ),
);
