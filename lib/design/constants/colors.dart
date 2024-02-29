import 'package:flutter/material.dart';

class ColorPalette {
  static Color white = const Color(0xFFFFFFFF);
  static Color black = const Color(0xFF000000);
  static Color transparent = const Color(0x00000000);

  static Color blue20 = const Color(0xffc7d6ff);

  static Color green20 = const Color(0xffb3dbcc);
  static Color green90 = const Color(0xFF00291a);

  static Color orange20 = const Color(0xfffdcdb4);
  static Color orange90 = const Color(0xFF4d1b00);

  static Color red60 = const Color(0xFFe61e25);
  static Color red80 = const Color(0xff7e1016);

  static Color purple60 = const Color(0xFF8929ff);
  static Color purple80 = const Color(0xFF6512c4);
  static Color purple90 = const Color(0xFF5411a2);
  static Color purple100 = const Color(0xFF3c0c73);

  static Color neutral10 = const Color(0xFFf9fafb);
  static Color neutral20 = const Color(0xFFeaebec);
  static Color neutral40 = const Color(0xFFced4d9);
  static Color neutral60 = const Color(0xFF6e757c);
  static Color neutral80 = const Color(0xFF353b40);
  static Color neutral90 = const Color(0xFF23262a);
  static Color neutral100 = const Color(0xFF0c0d0e);
}

class AppColors {
  final BrandColors brand;
  final FontColors font;
  final BackgroundColors background;
  final BorderColors border;

  const AppColors({
    required this.brand,
    required this.font,
    required this.background,
    required this.border,
  });
}

class BrandColors {
  final Color primary;
  final Color secondary;

  const BrandColors({
    required this.primary,
    required this.secondary,
  });
}

class FontColors {
  final Color primary;
  final Color secondary;
  final Color tertiary;
  final Color disabled;
  final Color interactive;
  final Color active;
  final Color info;
  final Color warning;
  final Color error;
  final Color success;

  const FontColors({
    required this.primary,
    required this.secondary,
    required this.tertiary,
    required this.disabled,
    required this.interactive,
    required this.active,
    required this.info,
    required this.warning,
    required this.error,
    required this.success,
  });
}

class BackgroundColors {
  final Color primary;
  final Color secondary;
  final Color tertiary;
  final Color disabled;
  final Color info;
  final Color warning;
  final Color error;
  final Color success;

  const BackgroundColors({
    required this.primary,
    required this.secondary,
    required this.tertiary,
    required this.disabled,
    required this.info,
    required this.warning,
    required this.error,
    required this.success,
  });
}

class BorderColors {
  final Color primary;
  final Color secondary;
  final Color tertiary;
  final Color disabled;
  final Color focus;
  final Color error;

  const BorderColors({
    required this.primary,
    required this.secondary,
    required this.tertiary,
    required this.disabled,
    required this.focus,
    required this.error,
  });
}
