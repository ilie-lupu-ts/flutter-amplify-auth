import 'package:flutter/material.dart';
import 'package:flutter_amplify_auth/design/constants/spacings.dart';
import 'package:flutter_amplify_auth/design/constants/text_styles.dart';
import 'package:flutter_amplify_auth/design/theme/app_theme.dart';

enum AlertVariant { error }

class Alert extends StatelessWidget {
  final AlertVariant variant;
  final String? title;
  final String message;

  const Alert({
    super.key,
    this.title,
    required this.variant,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Spacings.x_4),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          _icon,
          const SizedBox(width: Spacings.x_4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_titleText, style: TextStyles.heading.copyWith(color: _textColor)),
                Text(message, style: TextStyles.regular.copyWith(color: _textColor)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color get _backgroundColor {
    final colors = AppTheme.getColors();

    final colorMap = {
      AlertVariant.error: colors.background.error,
    };

    return colorMap[variant]!;
  }

  Color get _textColor {
    final colors = AppTheme.getColors();

    final colorMap = {
      AlertVariant.error: colors.font.error,
    };

    return colorMap[variant]!;
  }

  Widget get _icon {
    final colors = AppTheme.getColors();
    final iconMap = {
      AlertVariant.error: Icon(Icons.error, color: colors.font.error),
    };

    return iconMap[variant]!;
  }

  String get _titleText {
    if (title != null) {
      return title!;
    }

    final titleMap = {
      AlertVariant.error: "Error",
    };

    return titleMap[variant]!;
  }
}
