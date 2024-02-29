import 'package:flutter/material.dart';
import 'package:flutter_amplify_auth/design/constants/colors.dart';
import 'package:flutter_amplify_auth/design/theme/default.dart';
import 'package:flutter_amplify_auth/design/constants/text_styles.dart';

enum ButtonVariant { primary, secondary }

class Button extends StatelessWidget {
  final bool loading;
  final ButtonVariant variant;
  final String text;
  final void Function()? onPressed;

  const Button({
    super.key,
    this.variant = ButtonVariant.primary,
    this.text = '',
    this.onPressed,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor = _getBackgroundColor();
    final textColor = _getTextColor();

    return InkWell(
      onTap: loading ? null : onPressed,
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: loading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    color: Colors.white,
                  ),
                )
              : Text(
                  text,
                  style: TextStyles.button.copyWith(color: textColor),
                ),
        ),
      ),
    );
  }

  Color _getBackgroundColor() {
    if (onPressed == null) {
      return ColorPalette.neutral20;
    } else if (variant == ButtonVariant.primary) {
      return lightThemeColors.brand.primary;
    } else {
      return lightThemeColors.brand.primary;
    }
  }

  Color _getTextColor() {
    if (onPressed == null) {
      return ColorPalette.neutral80;
    } else if (variant == ButtonVariant.primary) {
      return Colors.white;
    } else {
      return Colors.white;
    }
  }
}
