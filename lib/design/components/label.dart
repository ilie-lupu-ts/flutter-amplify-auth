import 'package:flutter/material.dart';
import 'package:flutter_amplify_auth/design/theme/default.dart';
import 'package:flutter_amplify_auth/design/constants/text_styles.dart';

enum LabelVariant {
  defaultLabel,
  error,
}

class Label extends StatelessWidget {
  final String text;
  final Color color;
  final LabelVariant variant;

  const Label({
    super.key,
    required this.text,
    this.color = Colors.black,
    this.variant = LabelVariant.defaultLabel,
  });

  @override
  Widget build(BuildContext context) {
    final color = _getColor();

    return Text(
      text,
      style: TextStyles.regular.copyWith(
        color: color,
      ),
    );
  }

  Color _getColor() {
    if (variant == LabelVariant.error) {
      return lightThemeColors.font.error;
    }

    return lightThemeColors.font.primary;
  }
}
