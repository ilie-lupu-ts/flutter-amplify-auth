import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_amplify_auth/design/components/label.dart';
import 'package:flutter_amplify_auth/design/theme/default.dart';

enum AmplifyTextFieldSize { small, medium, large }

class AmplifyTextField extends StatelessWidget {
  final String? label;
  final String placeholder;
  final String? errorText;
  final AmplifyTextFieldSize size;
  final void Function(String)? onChanged;

  const AmplifyTextField({
    super.key,
    this.label,
    this.placeholder = "",
    this.onChanged,
    this.errorText,
    this.size = AmplifyTextFieldSize.medium,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Label(text: label!, variant: errorText != null ? LabelVariant.error : LabelVariant.defaultLabel),
          const SizedBox(height: 8),
        ],
        Container(
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: lightThemeColors.border.primary,
              width: 1,
            ),
          ),
          child: CupertinoTextField.borderless(
            placeholder: placeholder,
            placeholderStyle: const TextStyle(color: Colors.grey),
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            onChanged: (value) {
              onChanged?.call(value);
            },
          ),
        ),
        if (errorText != null) ...[
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.error_outline_outlined,
                color: lightThemeColors.font.error,
                size: 20,
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Label(
                  text: errorText!,
                  variant: LabelVariant.error,
                ),
              ),
            ],
          )
        ],
      ],
    );
  }
}
